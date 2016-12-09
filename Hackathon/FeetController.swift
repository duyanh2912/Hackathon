//
//  FeetController.swift
//  Hackathon
//
//  Created by Developer on 11/25/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

enum MoveType: String {
    case walk = "walk"
    case run = "run"
}

class FeetController: Controller {
    // VIEW
    var textures = [SKTexture]()
    
    // PROPERTIES
    var timePerFrame: Double = 1 / 30
    var isAnimating = false
    
    // FUNCTIONS
    
    func config(moveType: MoveType) {
        if let textures = Textures.animation["feet"]?[moveType.rawValue] {
            self.textures = textures
        }
        view.zPosition = ZPosition.FEET
        footPrints()
    }
    
    func animate() {
        view.run(.repeatForever(.animate(with: textures, timePerFrame: timePerFrame)), withKey: ACTION_KEY_ANIMATE)
        isAnimating = true
    }
    
    func stop() {
        view.removeAction(forKey: ACTION_KEY_ANIMATE)
        view.texture = Textures.FEET_IDLE
        isAnimating = false
    }
    
    func footPrints() {
        let delay = SKAction.wait(forDuration: 1)
        let footPrint = SKAction.run { [unowned self, unowned player = PlayerController.instance!] in
            let foot1 = SKSpriteNode(texture: self.view.texture, size: self.view.size)
//            let foot2 = SKSpriteNode(texture: self.view.texture, size: self.view.size)
            
            foot1.color = .yellow
            foot1.colorBlendFactor = 1
            foot1.blendMode = .add
            foot1.position = player.position
            foot1.zPosition = ZPosition.FOOTPRINT1
            foot1.zRotation = player.view.zRotation
            foot1.setScale(player.view.xScale)
//            foot1.alpha = 0.6
//            foot1.configLightningMask(mask: LightMask.DEFAULT)
            
//            foot2.alpha = 0.4
//            foot2.zPosition = ZPosition.FOOTPRINT2
//            foot2.configLightningMask(mask: LightMask.DEFAULT)
            
            self.parent.addChild(foot1)
//            foot1.addChild(foot2)
            
            let fade = SKAction.sequence([.wait(forDuration: 5), .fadeAlpha(to: 0, duration: 0.5), .removeFromParent()])
            foot1.run(fade)
//            foot2.run(fade)
        }
        
        parent.run(.repeatForever(.sequence([delay, footPrint])))
    }
}
