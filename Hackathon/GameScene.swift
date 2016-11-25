//
//  GameScene.swift
//  Hackathon
//
//  Created by Developer on 11/21/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let soundController = SoundController.sharedInstance
    var playerController = PlayerController.instance
    var zombieControllers = [ZombieController]()
    var wallControllers = [WallController]()
    
    deinit {
        print("bye GameScene")
    }
    
    override func didMove(to view: SKView) {
        configCamera()
        configPhysics()
        configBorder()
        configPlayer()
        configZombies()
        configGuns()
    }
    
    func configZombies() {
        for node in children {
            if node.name == "zombie" {
                let zombie = ZombieController(view: node as! View, parent: self)
                zombie.config()
                zombieControllers.append(zombie)
            }
        }
    }
    
    func configPlayer() {
        let player = self.childNode(withName: "player") as! View
        playerController.set(view: player, parent: self)
        playerController.config()
    }
    
    func configBorder() {
        for node in children {
            if node.name == "wall" {
                let controller = WallController(view: (node as! View), parent: self)
                controller.config()
                wallControllers.append(controller)
            }
            
            if node.name == "border" {
                for child in node.children[0].children {
                    let controller = WallController(view: (child as! View), parent: self)
                    controller.config()
                    wallControllers.append(controller)
                }
            }
        }
    }
    
    func configPhysics() {
        self.physicsWorld.contactDelegate = self
    }
    
    func configCamera() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            //            self.size = CGSize(width: size.height * 3 / 4 , height: size.height)
            self.size = CGSize(width: size.width, height: size.width * 4 / 3)
        }
    }
    
    func configGuns() {
        for node in children {
            if node.name == "handgun" {
                let gun = node.children[0].childNode(withName: "gun") as! View
                let controller = HandgunController(view: gun, parent: self)
                controller.config()
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node as? View, let nodeB = contact.bodyB.node as? View else {
            return
        }
        nodeA.handleContact?(nodeB)
        nodeB.handleContact?(nodeA)
    }
    
    override func didSimulatePhysics() {
        PlayerController.instance.move()
        camera?.position = PlayerController.instance.position
        for zombie in zombieControllers {
            zombie.move()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        for node in nodes(at: location) {
            if playerController.currentWeapon != .knife {
                if node.name == "zombie" {
                    playerController.shoot(at: location)
                    return
                }
            }
        }
        PlayerController.instance.touchLocation = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            PlayerController.instance.touchLocation = location
        }
    }
}
