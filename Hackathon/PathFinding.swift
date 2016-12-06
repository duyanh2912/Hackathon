//
//  PathFinding.swift
//  Hackathon
//
//  Created by Developer on 12/2/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import GameplayKit
import SpriteKit
import Foundation

struct PathFinder {
    static var instance: PathFinder!
    
    var pathFindingBufferRadius: Float
    var obstacleSpriteNodes: [SKSpriteNode]
    var polygonObstacles: [GKPolygonObstacle]
    let graph: GKObstacleGraph<GKGraphNode2D>
    
    init(obstacles: [SKSpriteNode], bufferRadius: Float) {
        self.pathFindingBufferRadius = bufferRadius
        self.obstacleSpriteNodes = obstacles
        self.polygonObstacles = SKNode.obstacles(fromNodePhysicsBodies: self.obstacleSpriteNodes)
        self.graph = GKObstacleGraph(obstacles: self.polygonObstacles, bufferRadius: pathFindingBufferRadius)
    }
    
    static func path(start: CGPoint, destination: CGPoint, graph: GKObstacleGraph<GKGraphNode2D>) -> CGPath {
        let startNode = GKGraphNode2D(point: float2(Float(start.x), Float(start.y)))
        let endNode = GKGraphNode2D(point: float2(Float(destination.x), Float(destination.y)))
        
        // Connect the two nodes just created to graph.
        graph.connectUsingObstacles(node: startNode)
        graph.connectUsingObstacles(node: endNode)
        
        // Find a path from the start node to the end node using the graph.
        let pathNodes:[GKGraphNode2D] = graph.findPath(from: startNode, to: endNode) as! [GKGraphNode2D]
        graph.remove([startNode, endNode])
        
        let path = UIBezierPath()
        for (index, node) in pathNodes.enumerated() {
            if index == 0 {
                path.move(to: node.toCGPoint())
                continue
            }
            if index == pathNodes.count - 1 {
                path.addLine(to: destination)
                continue
            }
            path.addLine(to: node.toCGPoint())
        }
        return path.cgPath
    }
    
    static func pathNodes(start: CGPoint, destination: CGPoint, graph: GKObstacleGraph<GKGraphNode2D>) -> [CGPoint] {
        let startNode = GKGraphNode2D(point: float2(Float(start.x), Float(start.y)))
        let endNode = GKGraphNode2D(point: float2(Float(destination.x), Float(destination.y)))
        
        // Connect the two nodes just created to graph.
        graph.connectUsingObstacles(node: startNode)
        graph.connectUsingObstacles(node: endNode)
        
        // Find a path from the start node to the end node using the graph.
        let pathNodes:[GKGraphNode2D] = graph.findPath(from: startNode, to: endNode) as! [GKGraphNode2D]
        graph.remove([startNode, endNode])
        
        var points = [CGPoint]()
        for node in pathNodes {
            points.append(node.toCGPoint())
        }
        return points
    }
}

protocol PathFindable: class {
    var pathFinder: PathFinder! { get set }
}

protocol SmartZombies: class, PathFindable {
    var smartZombieControllers: [SmartZombieController]! { get set }
    var lastUpdate: TimeInterval? { get set }

}
extension SmartZombies where Self: GameScene {
    func configPathFinder() {
        let obstacles = self["//wall"] as! [SKSpriteNode]
        //        obstacles += self["//zombie"] as! [SKSpriteNode]
        self.pathFinder = PathFinder(obstacles: obstacles, bufferRadius: Float(#imageLiteral(resourceName: "zombie").size.height / 2.6))
        PathFinder.instance = self.pathFinder
    }
    
    func configSmartZombies() {
        smartZombieControllers = [SmartZombieController]()
        for node in children {
            if node.name == "smartZombie" {
                let zombie = SmartZombieController(view: node as! View, parent: self)
                zombie.config()
                smartZombieControllers.append(zombie)
            }
        }
    }
    
    func zombiesPathUpdate() {
        for controller in self.smartZombieControllers {
                controller.updatePathNodes()
        }
    }
    
    func update(_ currentTime: TimeInterval) {
        guard lastUpdate != nil else {
            lastUpdate = currentTime
            zombiesPathUpdate()
            return
        }
        if currentTime - lastUpdate! > 0.05 {
            lastUpdate = currentTime
            zombiesPathUpdate()
        }
    }
}
