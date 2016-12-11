//
//  BoomFirstController.swift
//  Hackathon
//
//  Created by Phan Văn Đa on 12/9/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation
import SpriteKit
class MinePowerUpController: Controller {
    func config() {
        view.physicsBody = SKPhysicsBody(circleOfRadius: view.size.height / 2 * 0.8)
        view.physicsBody?.categoryBitMask = BitMasks.BOOMFIRST
        view.physicsBody?.contactTestBitMask = BitMasks.PLAYER
        view.physicsBody?.collisionBitMask = 0
        
        view.configLightningMask(mask: LightMask.DEFAULT)
        view.shadowCastBitMask = 0
        configHandleContact()
        
        view.zPosition = ZPosition.POWER_UP
    }
    func configHandleContact() {
        view.handleContact = { [unowned view = self.view!, unowned parent = self.parent!] other in
            view.removeFromParent()
            parent.run(SoundController.sharedInstance.PICK_UP)
            PlayerController.instance.numberOfMines += 1
        }
    }
}
