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
    var SPEED: CGFloat = 100
    var audio: SKAudioNode? = SKAudioNode(fileNamed: "zombie_moan")
    
    // ACTIONS
    
    var move: (() -> ())!
    func config() {
        view.zPosition = ZPosition.ZOMBIE
        configMove()
        configPhysics()
        configHandleContact()
        configSound()
        view.configLightningMask(mask: LightMask.DEFAULT)
    }
    
    func configSound() {
        guard audio != nil else { return }
        audio?.autoplayLooped = false
        view.addChild(audio!)
        let moan = SKAction.run { [unowned self] in
            if arc4random_uniform(2) == 0 {
                self.audio?.run(.play())
                print("play")
            }
        }
        let delay = SKAction.wait(forDuration: Double(arc4random_uniform(40) / 5 + 2))
        view.run(.repeatForever(.sequence([delay, moan])))
    }
    
    func configPhysics() {
        view.physicsBody = SKPhysicsBody(circleOfRadius: view.height / 1.8)
        view.configPhysicsMask(
            category: BitMasks.ZOMBIE,
            collision: BitMasks.ZOMBIE | BitMasks.WALL | BitMasks.PLAYER,
            contact: BitMasks.PLAYER | BitMasks.BULLET | BitMasks.BLAST
        )
        view.physicsBody?.friction = 0
    }
    
    func configHandleContact() {
        view.handleContact = { [unowned self]
            other in
            if other.physicsBody?.categoryBitMask == BitMasks.BULLET | BitMasks.BLAST{
                self.removeFromParent()
            }
            if other.physicsBody?.categoryBitMask == BitMasks.TRAP  {
                self.stopMoving(duration: 2)
            }
            if other.physicsBody?.categoryBitMask == BitMasks.BLAST {
                self.view.removeFromParent()
            }
        }
    }
    
    func removeFromParent() {
        view.removeFromParent()
        if var zombieControllers = (parent as? GameScene)?.zombieControllers {
            if let index = zombieControllers.index(where: {$0 === self}) {
                zombieControllers.remove(at: index)
                (parent as! GameScene).zombieControllers = zombieControllers
            }
        }
    }
    
    
    func configMove() {
        move = { [unowned self, unowned player = PlayerController.instance!] in
            guard self.view != nil else { return }
            let dx = player.position.x - self.position.x
            let dy = player.position.y - self.position.y
            
            guard abs(dx) > self.width / 8 || abs(dy) > self.height / 8  else {
                self.view.physicsBody?.isResting = true
                return
            }
            self.view.headToward(PlayerController.instance.position, spriteAngle: CGFloat.pi / 2, speed: self.SPEED)
        }
    }
    
    // Gọi hàm nếu muốn zombie dừng lại trong 1 khoảng thời gian nào đó
    func stopMoving(duration: Double){
        view.physicsBody?.isDynamic = false
        move = {}
        self.view.run(SKAction.wait(forDuration: duration)){[unowned self] in
            self.view.physicsBody?.isDynamic = true
            self.configMove()
        }
    }
}
