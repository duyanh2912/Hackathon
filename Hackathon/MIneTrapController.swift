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
        view.setScale(0.25)
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
            parent.run(SoundController.sharedInstance.EXPLOSION)
            
            let emitter = SKEmitterNode(fileNamed: "Explosion")
            emitter?.position = view.position
            emitter?.zPosition = ZPosition.BLAST
            
            let node = View(color: .clear, size: CGSize(width: 200, height: 200))
            node.position = view.position
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.height / 2)
            node.configPhysicsMask(category: BitMasks.BLAST, collision: 0, contact: BitMasks.ZOMBIE | BitMasks.PLAYER | BitMasks.BOOM)
         
            node.setScale(0.05)
            parent.addChild(node)
            parent.addChild(emitter!)
            
            node.run(.scale(to: 1, duration: 0.5)) {
                node.removeFromParent()
            }
            
            view.removeFromParent()
        }
    }
}
