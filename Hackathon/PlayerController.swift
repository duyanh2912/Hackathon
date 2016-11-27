//
//  PlayerController.swift
//  Hackathon
//
//  Created by Developer on 11/22/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

enum WeaponType: String {
    case knife = "knife"
    case handgun = "handgun"
}

enum PlayerState: String {
    case idle = "idle"
    case move = "move"
    case shoot = "shoot"
    case reload = "reload"
}

class PlayerController: Controller {
    static let instance = PlayerController()
    
    var view: View!
    weak var parent: SKNode!
    
    var timePerFrame: Double = 1/20
    var textures = [SKTexture]()
    var SPEED: CGFloat = 150
    var touchLocation: CGPoint?
    var feetController: FeetController!
    var currentWeapon: WeaponType = .knife {
        didSet {
            animate()
        }
    }
    var currentState: PlayerState = .idle
    required init() {
    }
    
    func set(view: View, parent: SKScene) {
        self.view = view
        self.parent = parent
        
        self.feetController = FeetController(
            view: view.childNode(withName: "feet") as! View,
            parent: parent
        )
        feetController.timePerFrame = self.timePerFrame
        feetController.config(moveType: .walk)
    }
    
    func config() {
        let xScale = view.xScale
        let yScale = view.yScale
        view.setScale(1)
        
        let texture = SKTexture(image: #imageLiteral(resourceName: "playerPhysicsBody"))
        view.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        view.physicsBody?.restitution = 0
        view.physicsBody?.allowsRotation = true
        
        view.physicsBody?.categoryBitMask = BitMasks.PLAYER.rawValue
        view.physicsBody?.collisionBitMask = BitMasks.WALL.rawValue
        view.physicsBody?.contactTestBitMask = BitMasks.ZOMBIE.rawValue
        
        view.xScale = xScale
        view.yScale = yScale
        configHandleContact()
        animate()
    }
    
    func configHandleContact() {
        view.handleContact = { [unowned self] other in
            if other.name == "zombie" {
                self.gameOver()
            }
        }
    }
    
    func gameOver() {
        if let gameoverScene = SKScene(fileNamed: "GameoverScene") {
            guard let scene = self.parent as? SKScene else { return }
            if UIDevice.current.userInterfaceIdiom == .pad {
                gameoverScene.size = CGSize(width: gameoverScene.size.width, height: gameoverScene.size.width * 1024 / 768)
            }
            gameoverScene.scaleMode = .aspectFill
            scene.view?.presentScene(gameoverScene)
        }
        reset()
    }
    
    func reset() {
        self.touchLocation = nil
        self.currentState = .idle
        self.currentWeapon = .knife
    }
    
    func move() {
        guard let destination = touchLocation else { return }
        let dx = destination.x - position.x
        let dy = destination.y - position.y
        
        guard abs(dx) > width / 8 || abs(dy) > height / 8  else {
            view.physicsBody?.isResting = true
            if currentState == .move {
                currentState = .idle
                animate()
            }
            feetController.stop()
            return
        }
        
        let angle = CGFloat.angleHeadTowardDestination(current: self.position, destination: destination, spriteAngle: 0)
        view.zRotation = angle
        
        var vector = CGVector(dx: dx, dy: dy)
        vector.scale(by: SPEED / destination.distance(to: position))
        view.physicsBody?.velocity = vector
        view.physicsBody?.angularVelocity = 0
        
        if currentState == .idle {
            currentState = .move
            self.animate()
        }
        if feetController.view.action(forKey: ACTION_KEY_ANIMATE) == nil {
            feetController.animate()
        }
    }
    
    func animate(repeatForever: Bool = true, completion: @escaping () -> () = {}) {
        stop()
        if let textures = Textures.animation[currentWeapon.rawValue]?[currentState.rawValue] {
            self.textures = textures
            let animate = SKAction.animate(with: textures, timePerFrame: timePerFrame)
            let completion = SKAction.run(completion)
            let action = SKAction.sequence([animate, completion])
            if repeatForever {
                view.run(.repeatForever(action), withKey: ACTION_KEY_ANIMATE)
            } else {
                view.run(action, withKey: ACTION_KEY_ANIMATE)
            }
        }
    }
    
    func stop() {
        view.removeAction(forKey: ACTION_KEY_ANIMATE)
    }
    
    func shoot(at location: CGPoint) {
        guard currentState != .reload, currentState != .shoot else { return }
        currentState = .shoot
        touchLocation = position
        view.physicsBody?.isResting = true
        
        let dx = location.x - position.x
        let dy = location.y - position.y
        
        var angle = atan(dy / dx)
        angle = (dx < 0) ? (angle + CGFloat.pi) : angle
        
        let shoulder = view.childNode(withName: "shoulder")!
        angle += asin(shoulder.position.distance(to: CGPoint.zero) * view.xScale / location.distance(to: position))
        view.zRotation = angle
       
        let bullet = View(texture: Textures.BULLET, size: Textures.BULLET.size().applying(CGAffineTransform.init(scaleX: 0.75, y: 0.75)))
        let controller = BulletController(view: bullet, parent: parent)
        controller.config(destination: location)
        
        self.animate(repeatForever: false) { [unowned self] in
            self.currentState = .reload
            self.animate(repeatForever: false) {
                self.currentState = .idle
                self.animate()
            }
        }
    }
}
