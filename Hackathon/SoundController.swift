//
//  SoundController.swift
//  Session1
//
//  Created by Developer on 11/12/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation
import SpriteKit

class SoundController {
    let GAME_OVER = SKAction.playSoundFileNamed("game_over", waitForCompletion: false)
    let HANDGUN_FIRE = SKAction.playSoundFileNamed("handgun_fire", waitForCompletion: false)
    let TRAP = SKAction.playSoundFileNamed("trap", waitForCompletion: false)
    let EXPLOSION = SKAction.playSoundFileNamed("explosion", waitForCompletion: false)
    let PICK_UP = SKAction.playSoundFileNamed("pick_up", waitForCompletion: false)
    
    static let sharedInstance = SoundController()
    
    deinit {
        print("bye Sound Controller")
    }
}
