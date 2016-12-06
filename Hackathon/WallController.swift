//
//  WallController.swift
//  Hackathon
//
//  Created by Developer on 11/24/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class WallController: Controller {
    func config() {
        view.physicsBody = SKPhysicsBody(rectangleOf: view.size)
        view.physicsBody?.isDynamic = false
        view.physicsBody?.categoryBitMask = BitMasks.WALL
        view.physicsBody?.contactTestBitMask = 0
        view.physicsBody?.collisionBitMask = (view.physicsBody?.collisionBitMask)! ^ BitMasks.WALL
        
        view.configLightningMask(mask: LightMask.DEFAULT)
    }
}
