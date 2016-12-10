//
//  StatueZombieController.swift
//  Hackathon
//
//  Created by Developer on 12/10/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class StatueZombieController: ZombieController {
    override func configMove() {
        move = {}
    }
    
    override init(view: View, parent: SKNode) {
        super.init(view: view, parent: parent)
        view.colorBlendFactor = 0.5
        view.color = UIColor(red: 0, green: 112, blue: 209, alpha: 1)
    }
    
    override func configHandleContact() {
        view.handleContact = { _ in}
    }
    
    override func configPhysics() {
        super.configPhysics()
        view.physicsBody?.mass = (view.physicsBody?.mass)! * 50
        view.configPhysicsMask(category: BitMasks.STATUE, collision: BitMasks.PLAYER | BitMasks.ZOMBIE | BitMasks.WALL, contact: 0)
//        view.physicsBody?.isDynamic = false
    }
}
