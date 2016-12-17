//
//  BoomController.swift
//  Hackathon
//
//  Created by Phan Văn Đa on 12/9/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation
import SpriteKit
class MineTrapController: Controller{
    init(parent: SKNode) {
        super.init(view: View(texture: Textures.MINE), parent: parent)
        view.setScale(0.25 * 2 / 3)
    }
    
    override init(view: View, parent: SKNode) {
        super.init(view: view, parent: parent)
    }
    
    func config() {
        view.physicsBody = SKPhysicsBody(circleOfRadius: view.size.height / 2)
        view.physicsBody?.categoryBitMask = BitMasks.BOOM
        view.physicsBody?.contactTestBitMask = BitMasks.PLAYER | BitMasks.ZOMBIE | BitMasks.WALL
        view.physicsBody?.collisionBitMask = 0
        
        view.configLightningMask(mask: LightMask.DEFAULT)
        view.shadowCastBitMask = 0
        view.zPosition = ZPosition.MINE_TRAP
        configHandleContact()
    }
    func configHandleContact() {
        
        view.handleContact = { [unowned view = self.view!, unowned parent = self.parent!] other in
            let bc = BlastController(parent: parent)
            bc.config(position: view.position)
            
            view.removeFromParent()
        }
    }
}
