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
        view.physicsBody = SKPhysicsBody(rectangleOf: view.size)
        view.physicsBody?.categoryBitMask = BitMasks.GIFT
        view.physicsBody?.contactTestBitMask = BitMasks.PLAYER
        view.physicsBody?.collisionBitMask = 0
        
        view.configLightningMask(mask: LightMask.DEFAULT)
        configHandleContact()
    }
    func configHandleContact() {
        view.handleContact = { [unowned view = self.view!, unowned parent = self.parent as! GameScene] other in
            view.removeFromParent()
            for node in parent.zombieControllers{
                node.stopMoving(duration: 5)
            }
            for node in parent.smartZombieControllers {
                node.stopMoving(duration: 5)
            }
        }
    }
}
