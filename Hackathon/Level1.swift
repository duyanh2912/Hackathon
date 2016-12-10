//
//  File.swift
//  Hackathon
//
//  Created by Developer on 11/29/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class Level1: GameScene, TriangleLight {
    var isUsingTriangeLight: Bool = true
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        configTriangeLight()
        for zombie in allZombies {
            zombie.SPEED = 75
        }
    }
    
    override func configPlayer() {
        super.configPlayer()
        playerController.lightNode.falloff = 2
    }
}
