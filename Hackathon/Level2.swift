//
//  Level2.swift
//  Hackathon
//
//  Created by Developer on 12/3/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import SpriteKit
import Foundation

class Level2: GameScene {
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        playerController.lightNode.falloff = 2.5
    }
}

