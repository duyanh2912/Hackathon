//
//  Level3.swift
//  Hackathon
//
//  Created by Developer on 12/2/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class Level3: Level1, SmartZombies {
    
    // Pathfinding Properties
    var pathFinder: PathFinder!
    
    // Smart Zombies default properties
    var lastUpdate: TimeInterval? = nil
    var lastPlayerPosition: CGPoint? = nil
    var smartZombieControllers: [SmartZombieController]! = [SmartZombieController]()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        configSmartZombies()
    }
   
    override func configCamera() {
        super.configCamera()
        //self.camera = nil
    }
    
    override func configBorder() {
        super.configBorder()
        let obstacles = self["//wall"] as! [SKSpriteNode]
//        obstacles += self["//zombie"] as! [SKSpriteNode]
        self.pathFinder = PathFinder(obstacles: obstacles, bufferRadius: Float(#imageLiteral(resourceName: "zombie").size.height / 2.6))
        PathFinder.instance = self.pathFinder
    }
    
    override func configPlayer() {
        super.configPlayer()
        //playerController.lightNode.isEnabled = false
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        for controller in smartZombieControllers {
            zombiesPathUpdate()
            controller.move()
        }
    }
}

