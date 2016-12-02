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
    var view: View!
    weak var parent: SKNode!
    
    // PROPERTIES
    var timePerFrame: Double = 1 / 30
    var isAnimating = false
    
    // FUNCTIONS
    required init() {}
    
    func config(moveType: MoveType) {
        if let textures = Textures.animation["feet"]?[moveType.rawValue] {
            self.textures = textures
        }
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
    
}
