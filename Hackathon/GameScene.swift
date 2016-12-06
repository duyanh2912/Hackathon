//
//  GameScene.swift
//  Hackathon
//
//  Created by Developer on 11/21/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import AVFoundation
import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate, SmartZombies {
    let soundController = SoundController.sharedInstance
    var playerController: PlayerController!
    var zombieControllers = [ZombieController]()
    var wallControllers = [WallController]()
    static var audioPlayer: AVAudioPlayer?
    
    // Smart Zombies Properties
    var smartZombieControllers: [SmartZombieController]!
    var lastUpdate: TimeInterval? = nil
    var pathFinder: PathFinder!
    
    deinit {
        print("bye GameScene")
        playerController.reset()
    }
    
    override func didMove(to view: SKView) {
        configMusic()
        configCamera()
        configPhysics()
        configPlayer()
        configBorder()
        configZombies()
        configGuns()
        configExit()
        configPathFinder()
        configSmartZombies()
    }
    
    func configMusic() {
        guard GameScene.audioPlayer == nil else { return }
        
        if let path = Bundle.main.url(forResource: "background", withExtension: "mp3") {
            print("music")
            GameScene.audioPlayer = try! AVAudioPlayer(contentsOf: path)
            GameScene.audioPlayer?.volume = 0.75
            GameScene.audioPlayer?.numberOfLoops = -1
            GameScene.audioPlayer?.play()
        }
    }
    
    func configExit() {
        if let exit = childNode(withName: "exit") as? View {
            let controller = ExitController(view: exit, parent: self)
            controller.config()
        }
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
        playerController = PlayerController(view: player, parent: self)
        playerController.config()
        self.listener = player
        PlayerController.instance = playerController
    }
    
    func configBorder() {
        self.enumerateChildNodes(withName: "//wall") { [unowned self]
            (node, stop) in
            let controller = WallController(view: node as! View, parent: self)
            controller.config()
            self.wallControllers.append(controller)
        }
    }
    
    func configPhysics() {
        self.physicsWorld.contactDelegate = self
    }
    
    func configCamera() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            //            self.size = CGSize(width: size.height * 3 / 4 , height: size.height)
            self.size = CGSize(width: size.width, height: size.width * 4 / 3)
        } else {
            self.size = CGSize(width: size.width, height: size.width * 16 / 9)
        }
        
        let camera = SKCameraNode()
        camera.setScale(540 / size.width)
        self.addChild(camera)
        self.camera = camera
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
        for zombie in zombieControllers { zombie.move() }
        for smart in smartZombieControllers { smart.move() }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard lastUpdate != nil else {
            lastUpdate = currentTime
            zombiesPathUpdate()
            return
        }
        if currentTime - lastUpdate! > 0.05 {
            lastUpdate = currentTime
            zombiesPathUpdate()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        for node in nodes(at: location) {
            if playerController.currentWeapon != .knife {
                if node.physicsBody?.categoryBitMask == BitMasks.ZOMBIE {
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
