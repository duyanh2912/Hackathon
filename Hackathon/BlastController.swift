//
//  BlastController.swift
//  Hackathon
//
//  Created by Developer on 12/14/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class BlastController: Controller {
    init(parent: SKNode) {
        super.init(view: View(color: .clear, size: CGSize(width: 200, height: 200)), parent: parent)
    }
    
    func config(position: CGPoint, scale: CGFloat = 1) {
        parent.run(SoundController.sharedInstance.EXPLOSION)
        
        guard let emitter = SKEmitterNode(fileNamed: "Explosion") else { return }
        emitter.position = position
        emitter.zPosition = ZPosition.BLAST
        emitter.setScale(emitter.xScale * scale)
        
        view.position = position
        view.setScale(view.xScale * scale)
        view.physicsBody = SKPhysicsBody(circleOfRadius: view.size.height / 2)
        view.configPhysicsMask(category: BitMasks.BLAST, collision: 0, contact: BitMasks.ZOMBIE | BitMasks.PLAYER | BitMasks.BOOM)
        
        view.setScale(0.05)
        parent.addChild(view)
        parent.addChild(emitter)
        
        view.run(.scale(to: 1, duration: 0.5)) { [unowned view = self.view!] in
            view.removeFromParent()
        }

    }
}
