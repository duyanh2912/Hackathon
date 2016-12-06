//
//  ExitController.swift
//  Hackathon
//
//  Created by Developer on 11/27/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class ExitController: Controller {
    // MODEL
    
    
    // VIEW
    
    // CONTROLLER
    
    func config() {
        view.physicsBody = SKPhysicsBody(rectangleOf: view.size.applying(.init(scaleX: 0.5, y: 0.5)))
        view.configPhysicsMask(category: BitMasks.EXIT, collision: 0, contact: BitMasks.PLAYER)
        
        view.handleContact = { [unowned parent = (self.parent as! SKScene)]
            other in
            WinScene.present(view: parent.view!)
        }
        
        view.configLightningMask(mask: LightMask.DEFAULT)
        view.shadowCastBitMask = 0
    }
}
