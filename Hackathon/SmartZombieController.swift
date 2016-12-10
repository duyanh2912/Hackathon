//
//  AdvancedZombieController.swift
//  Hackathon
//
//  Created by Developer on 12/2/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import GameplayKit
import SpriteKit
import Foundation

class SmartZombieController: ZombieController {
    var pathNodes: [CGPoint]!
    var currentTargetNodeIndex: Int = 0
    
    func updatePathNodes() {
        pathNodes = PathFinder.pathNodes(start: view.position, destination: PlayerController.instance.position, graph: PathFinder.instance.graph)
//        pathNodes.removeFirst()
        currentTargetNodeIndex = 0
        move()
    }
    
    override func configMove() {
        move = {
        guard self.view != nil else { return }
        guard self.currentTargetNodeIndex < self.pathNodes.count else {
            self.view.physicsBody?.isResting = true
            return
        }
        
        let dx = self.pathNodes[self.currentTargetNodeIndex].x - self.position.x
        let dy = self.pathNodes[self.currentTargetNodeIndex].y - self.position.y
            if !(abs(dx) > self.width / 8 || abs(dy) > self.height / 8) {
            self.currentTargetNodeIndex += 1
        }
       
        self.view.headToward(self.pathNodes[self.currentTargetNodeIndex], spriteAngle: CGFloat.pi / 2, speed: self.SPEED)
        }
    }
    
    override func removeFromParent() {
        view.removeFromParent()
        if var zombieControllers = (parent as? GameScene)?.smartZombieControllers {
            if let index = zombieControllers.index(where: {$0 === self}) {
                zombieControllers.remove(at: index)
                (parent as! GameScene).smartZombieControllers = zombieControllers
            }
        }
    }
}
