//
//  SuperZombie.swift
//  Hackathon
//
//  Created by Developer on 12/10/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class SuperZombieController: ZombieController {
    override func config() {
        super.config()
        configEyeRay()
    }
    
    func configEyeRay() {
        guard let emiter = SKEmitterNode(fileNamed: "EyeRay") else { return }
        emiter.position = CGPoint(x: 0, y: 13.5)
        emiter.zPosition = ZPosition.EYE_RAY
        view.addChild(emiter)
        
        let node = SKNode()
        node.position = CGPoint(x: 0, y: 72.5)
        node.physicsBody = SKPhysicsBody(texture: Textures.RAY, size: Textures.RAY.size())
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
