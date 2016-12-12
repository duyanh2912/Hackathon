//
//  GiftController.swift
//  Hackathon
//
//  Created by Phan Văn Đa on 12/9/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation
import SpriteKit
class StuntPowerUpController: Controller{
    func config() {
        view.physicsBody = SKPhysicsBody(rectangleOf: view.size.scale(by: 0.5))
        view.physicsBody?.categoryBitMask = BitMasks.GIFT
        view.physicsBody?.contactTestBitMask = BitMasks.PLAYER
        view.physicsBody?.collisionBitMask = 0
        
        view.configLightningMask(mask: LightMask.DEFAULT)
        view.shadowCastBitMask = 0
        view.zPosition = ZPosition.STUNT_POWER_UP
        configHandleContact()
    }
    func configHandleContact() {
        view.handleContact = { [unowned view = self.view!, unowned parent = self.parent as! GameScene] other in
            parent.run(SoundController.sharedInstance.PICK_UP)
            view.removeFromParent()
            for node in parent.allZombies{
                if node is StatueZombieController { continue }
                node.stopMoving(duration: 5)
            }
        }
    }
}
