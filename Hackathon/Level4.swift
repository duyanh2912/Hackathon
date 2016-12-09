//
//  Level4.swift
//  Hackathon
//
//  Created by Developer on 12/10/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class Level4: GameScene {
    override func configZombies() {
        for node in children {
            if node.name == "zombie" {
                let zombie = ZombieController(view: node as! View, parent: self)
                zombie.audio = SKAudioNode(fileNamed: "tha_thu")
                zombie.config()
                zombieControllers.append(zombie)
            }
        }
    }
    
    override func configPlayer() {
        let player = self.childNode(withName: "player") as! View
        playerController = SpecialPlayerController(view: player, parent: self)
        PlayerController.instance = playerController
        playerController.config()
        
        self.listener = player
        playerController.lightNode.falloff = 2
    }
}
