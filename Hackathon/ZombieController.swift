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
    
    var SPEED: CGFloat = 100
    var audio = SKAudioNode(fileNamed: "zombie_moan")
    
    required init() {}
    
    func config() {
        configPhysics()
        configHandleContact()
        
        audio.autoplayLooped = false
        view.addChild(audio)
        let moan = SKAction.run { [unowned self] in
            if arc4random_uniform(2) == 0 {
                self.audio.run(.play())
                print("play")
            }
        }
        let delay = SKAction.wait(forDuration: Double(arc4random_uniform(40) / 5 + 2))
        view.run(.repeatForever(.sequence([delay, moan])))
        
        view.configLightningMask(mask: LightMask.DEFAULT.rawValue)
    }
    
    func configPhysics() {
        view.physicsBody = SKPhysicsBody(circleOfRadius: view.height / 1.8)
        view.configPhysicsMask(
            category: BitMasks.ZOMBIE.rawValue,
            collision: BitMasks.ZOMBIE.rawValue | BitMasks.WALL.rawValue,
            contact: BitMasks.PLAYER.rawValue | BitMasks.BULLET.rawValue
        )
        view.physicsBody?.friction = 0
    }
    
    func configHandleContact() {
        view.handleContact = { [unowned view = self.view!, weak parent = self.parent as? GameScene, unowned self]
            other in
            view.removeFromParent()
            if var zombieControllers = parent?.zombieControllers {
                if let index = zombieControllers.index(where: {$0 === self}) {
                    zombieControllers.remove(at: index)
                    parent?.zombieControllers = zombieControllers
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
        view.headToward(PlayerController.instance.position, spriteAngle: CGFloat.pi / 2, speed: SPEED)
    }
}
