//
//  HandgunController.swift
//  Hackathon
//
//  Created by Developer on 11/25/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class HandgunController: Controller {
    var view: View!
    weak var parent: SKNode!
    
    required init() {}
    
    func config() {
        view.physicsBody = SKPhysicsBody(rectangleOf: view.size.applying(.init(scaleX: 0.5, y: 0.5)))
        view.physicsBody?.categoryBitMask = BitMasks.HANDGUN.rawValue
        view.physicsBody?.collisionBitMask = 0
        view.physicsBody?.contactTestBitMask = BitMasks.PLAYER.rawValue
        
        view.handleContact = { [unowned view = self.view!] other in
            view.removeFromParent()
            PlayerController.instance.currentWeapon = .handgun
        }
    }
}
