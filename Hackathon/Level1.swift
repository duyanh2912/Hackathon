//
//  File.swift
//  Hackathon
//
//  Created by Developer on 11/29/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class Level1: GameScene {
    override func configZombies() {
        enumerateChildNodes(withName: "zombie") { [unowned self]
            (node, stop) in
            let controller = ZombieController(view: node as! View, parent: self)
            controller.SPEED = 75
            controller.config()
            self.zombieControllers.append(controller)
        }
    }
    
    override func configPlayer() {
        super.configPlayer()
        playerController.lightNode.falloff = 2
    }
}
