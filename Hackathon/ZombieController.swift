//
//  ZombieController.swift
//  Hackathon
//
//  Created by Developer on 11/22/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class ZombieController: Controller {
    var view: View!
    weak var parent: SKScene!
    
    var SPEED: CGFloat = 75
    
    required init() {}
    
    func config() {
        view.physicsBody = SKPhysicsBody(texture: view.texture!, size: view.size)
        view.physicsBody?.categoryBitMask = BitMasks.ZOMBIE.rawValue
        view.physicsBody?.collisionBitMask = BitMasks.WALL.rawValue | BitMasks.ZOMBIE.rawValue
        view.physicsBody?.contactTestBitMask = BitMasks.PLAYER.rawValue
    }
    
    func move() {
        let dx = PlayerController.instance.position.x - self.position.x
        let dy = PlayerController.instance.position.y - self.position.y
        
        guard abs(dx) > width / 8 || abs(dy) > height / 8  else {
            view.physicsBody?.isResting = true
            return
        }
        
        var angle = atan(dy / dx)
        angle = (dx < 0) ? (angle + CGFloat.pi) : angle
        view.zRotation = angle - CGFloat.pi / 2
        
        var vector = CGVector(dx: dx, dy: dy)
        vector.scale(by: SPEED / PlayerController.instance.position.distance(to: position))
        view.physicsBody?.velocity = vector
    }
}
