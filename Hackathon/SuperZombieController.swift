//
//  SuperZombie.swift
//  Hackathon
//
//  Created by Developer on 12/10/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

let PLAYER_SPEED_UP = "player_speed_up"

class SuperZombieController: ZombieController {
    override func config() {
        configEyeRay()
        super.config()
        
    }
    
    func configEyeRay() {
        guard let emiter = SKEmitterNode(fileNamed: "EyeRay") else { return }
        emiter.position = CGPoint(x: 0, y: 13.5)
        emiter.zPosition = ZPosition.EYE_RAY
        view.addChild(emiter)
        
        let node = View(texture: Textures.RAY)
        node.name = "eye_ray"
        node.position = CGPoint(x: 0, y: 50)
        node.zPosition = -50
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.configPhysicsMask(category: BitMasks.EYE_RAY, collision: 0, contact: BitMasks.PLAYER)
        view.addChild(node)
    }
    
    override func removeFromParent() {
        view.removeFromParent()
        if var zombieControllers = (parent as? GameScene)?.superZombieControllers {
            if let index = zombieControllers.index(where: {$0 === self}) {
                zombieControllers.remove(at: index)
                (parent as! GameScene).superZombieControllers = zombieControllers
            }
        }
    }
}
