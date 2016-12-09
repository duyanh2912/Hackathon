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
            let footprint = SKSpriteNode(texture: self.view.texture, size: self.view.size)
            
            footprint.name = "footprint"
            footprint.color = .yellow
            footprint.colorBlendFactor = 1
            footprint.blendMode = .add
            footprint.position = player.position
            
            for node in (self.parent as! GameScene).nodes(at: footprint.position){
                if node.name == "footprint" {
                    node.removeFromParent()
                }
            }
            footprint.zPosition = ZPosition.FOOTPRINT1
            footprint.zRotation = player.view.zRotation
            footprint.setScale(player.view.xScale)

            self.parent.addChild(footprint)
            
            let fade = SKAction.sequence([.wait(forDuration: 5), .fadeAlpha(to: 0, duration: 0.5), .removeFromParent()])
            footprint.run(fade)
        }
        
        parent.run(.repeatForever(.sequence([footPrint, delay])))
    }
}
