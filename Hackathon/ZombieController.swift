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
    weak var parent: SKNode!
    
    var SPEED: CGFloat = 120
    
    required init() {}
    
    func config() {
        view.physicsBody = SKPhysicsBody(texture: view.texture!, size: view.size)
        view.physicsBody?.categoryBitMask = BitMasks.ZOMBIE.rawValue
        view.physicsBody?.collisionBitMask = BitMasks.WALL.rawValue | BitMasks.ZOMBIE.rawValue
        view.physicsBody?.contactTestBitMask = BitMasks.PLAYER.rawValue
        
        view.handleContact = { [unowned view = self.view!, weak parent = self.parent as? GameScene, unowned self]
            other in
            view.removeFromParent()
            self.view = nil
            if var zombieControllers = parent?.zombieControllers {
                if let index = zombieControllers.index(where: {$0 === self}) {
                zombieControllers.remove(at: index)
                }
            }
        }
    }
    
    func move() {
        guard view != nil else { return }
        let dx = PlayerController.instance.position.x - self.position.x
        let dy = PlayerController.instance.position.y - self.position.y
        
        guard abs(dx) > width / 8 || abs(dy) > height / 8  else {
            view.physicsBody?.isResting = true
            return
        }
        view.zRotation = CGFloat.angleHeadTowardDestination(current: self.position, destination: PlayerController.instance.position, spriteAngle: CGFloat.pi / 2)
        
        var vector = CGVector(dx: dx, dy: dy)
        vector.scale(by: SPEED / PlayerController.instance.position.distance(to: position))
        view.physicsBody?.velocity = vector
    }
}
