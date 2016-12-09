//
//  GiftController.swift
//  Hackathon
//
//  Created by Phan Văn Đa on 12/9/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation
import SpriteKit
class GiftController: Controller{
    func config() {
        view.physicsBody = SKPhysicsBody(rectangleOf: view.size)
        view.physicsBody?.categoryBitMask = BitMasks.GIFT
        view.physicsBody?.contactTestBitMask = BitMasks.PLAYER
        view.physicsBody?.collisionBitMask = 0
        
        view.configLightningMask(mask: LightMask.DEFAULT)
        configHandleContact()
    }
    func configHandleContact() {
        view.handleContact = { [unowned self] other in
            if other.physicsBody?.categoryBitMask == BitMasks.PLAYER {
                self.view.removeFromParent()
                for node in (self.parent as! GameScene).zombieControllers{
                    node.stopMoving()
                }
            }
        }
    }
}
