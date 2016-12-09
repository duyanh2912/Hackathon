//
//  TrapController.swift
//  Hackathon
//
//  Created by Phan Văn Đa on 12/9/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation
import SpriteKit
class TrapController: Controller{
    func config() {
        view.physicsBody = SKPhysicsBody(rectangleOf: view.size)
        view.physicsBody?.categoryBitMask = BitMasks.TRAP
        view.physicsBody?.contactTestBitMask = BitMasks.PLAYER | BitMasks.ZOMBIE
        view.physicsBody?.collisionBitMask = 0
        
        view.configLightningMask(mask: LightMask.DEFAULT)
        configHandleContact()
    }
    func configHandleContact() {
        view.handleContact = { [unowned view = self.view!, unowned parent = self.parent as! GameScene] other in
            view.removeFromParent()
        }
    }
}
