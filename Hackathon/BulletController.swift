//
//  BulletController.swift
//  Hackathon
//
//  Created by Developer on 11/25/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class BulletController: Controller {
    var view: View!
    weak var parent: SKNode!
    
    var SPEED: CGFloat = 160
    
    required init() {}
    
    func config(destination: CGPoint) {
        view.position = PlayerController.instance.nose
      
        view.physicsBody = SKPhysicsBody(rectangleOf: view.size)
        view.physicsBody?.categoryBitMask = BitMasks.BULLET.rawValue
        view.physicsBody?.collisionBitMask = 0
        view.physicsBody?.contactTestBitMask = BitMasks.ZOMBIE.rawValue | BitMasks.WALL.rawValue
        
        view.lightingBitMask = 1
        
        view.handleContact = { [unowned view = self.view!] other in
            view.removeFromParent()
        }
        PlayerController.instance.view.addChild(view)
        view.move(toParent: parent)
        
        let dx = destination.x - position.x
        let dy = destination.y - position.y
        
        var vector = CGVector(dx: dx, dy: dy)
        vector = vector.scale(by: SPEED / destination.distance(to: position))
        view.physicsBody?.velocity = vector
        
        var angle = atan(dy / dx)
        angle = (dx < 0) ? (angle + CGFloat.pi) : angle
        view.zRotation = angle
        
        
    }
}
