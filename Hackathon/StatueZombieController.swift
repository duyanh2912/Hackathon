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
        view.color = UIColor(red: 0/255, green: 112/255, blue: 209/255, alpha: 1)
    }
    
    override func configSound() {}
    
    override func configHandleContact() {
        view.handleContact = { _ in}
    }
    
    override func configPhysics() {
        super.configPhysics()
        view.physicsBody?.mass = (view.physicsBody?.mass)! * 50
        view.configPhysicsMask(category: BitMasks.STATUE, collision: BitMasks.PLAYER | BitMasks.ZOMBIE | BitMasks.WALL | BitMasks.STATUE, contact: 0)
//        view.physicsBody?.isDynamic = false
    }
    
    override func removeFromParent() {
        view.removeFromParent()
        if var zombieControllers = (parent as? GameScene)?.statueZombieControllers {
            if let index = zombieControllers.index(where: {$0 === self}) {
                zombieControllers.remove(at: index)
                (parent as! GameScene).statueZombieControllers = zombieControllers
            }
        }
    }
}
