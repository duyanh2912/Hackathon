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
    static var instance: PlayerController!
    
    // VIEW
    var textures = [SKTexture]()
    
    // PROPERTIES
    var currentWeapon: WeaponType = .knife {
        didSet {
            animate()
        }
    }
    var currentState: PlayerState = .idle
    var SPEED: CGFloat = 150
    var touchLocation: CGPoint?
    var timePerFrame: Double = 1/20  //Animation
    
    // CHILDREN
    var lightNode = SKLightNode()
    var feetController: FeetController!
    var shoulder: CGPoint {
        switch currentWeapon {
        case .handgun:
            return .init(x: 0, y: -53)
        default:
            return .zero
        }
    }
    var nose: CGPoint {
        switch currentWeapon {
        case .handgun:
            return .init(x: 117.5, y: -53)
        default:
            return .zero
        }
    }
    
    // FUNCTIONS
    
    // Dùng hàm set() thay cho init()
    override init(view: View, parent: SKNode) {
        super.init(view: view, parent: parent)
        
        self.feetController = FeetController(
            view: view.childNode(withName: "feet") as! View,
            parent: parent
        )
        feetController.timePerFrame = self.timePerFrame
        feetController.config(moveType: .walk)
    }
    
    // Chỉnh physics + lightning
    func config() {
        view.physicsBody = SKPhysicsBody(circleOfRadius: view.size.height / 2 * 0.7)
        view.physicsBody?.restitution = 0
        view.physicsBody?.allowsRotation = true
        
        view.physicsBody?.categoryBitMask = BitMasks.PLAYER
        view.physicsBody?.collisionBitMask = BitMasks.WALL
        view.physicsBody?.contactTestBitMask = BitMasks.ZOMBIE
    
        configHandleContact()
        animate()
        
        view.addChild(lightNode)
        lightNode.categoryBitMask = 1
        lightNode.falloff = 3
    }
    
    func configHandleContact() {
        view.handleContact = { [unowned self] other in
            if other.physicsBody?.categoryBitMask == BitMasks.ZOMBIE {
                self.gameOver()
            }
        }
    }
    
    // Chuyển sang scene Game Over
    func gameOver() {
        if let gameoverScene = SKScene(fileNamed: "GameoverScene") {
            guard let scene = self.parent as? SKScene else { return }
            if UIDevice.current.userInterfaceIdiom == .pad {
                gameoverScene.size = CGSize(width: gameoverScene.size.width, height: gameoverScene.size.width * 1024 / 768)
            }
            gameoverScene.scaleMode = .aspectFill
            scene.view?.presentScene(gameoverScene)
        }
    }
    
    // Vì PlayerController là singleton nên mỗi lần chơi lại phải reset
    func reset() {
        self.touchLocation = nil
        self.currentState = .idle
        self.currentWeapon = .knife
    }
    
    // Hàm move() đc gọi trong update của GameScene
    func move() {
        
        // Nếu người chơi chưa chạm tay vào màn hình (touchLocation == nil) thì return luôn
        guard let destination = touchLocation else { return }
        let dx = destination.x - position.x
        let dy = destination.y - position.y
        
        // Khi player đến đủ gần touchLocation thì dừng việc chuyển động lại
        guard abs(dx) > width / 8 || abs(dy) > height / 8  else {
            view.physicsBody?.isResting = true
            if currentState == .move {
                currentState = .idle
                animate()
            }
            feetController.stop()
            return
        }
        
        // Xoay player về phía touchLocation
        let angle = CGFloat.angleHeadTowardDestination(current: self.position, destination: destination, spriteAngle: 0)
        view.zRotation = angle
        
        // Gắn vector vận tốc cho player
        var vector = CGVector(dx: dx, dy: dy)
        vector = vector.scale(by: SPEED / destination.distance(to: position))
        view.physicsBody?.velocity = vector
        view.physicsBody?.angularVelocity = 0
        
        if currentState == .idle {
            currentState = .move
            self.animate()
        }
        
        // Nếu feet chưa animate thì cho nó animate
        if !feetController.isAnimating {
            feetController.animate()
        }
    }
    
    // Hàm animate được gọi sau mỗi lần chuyển currentState hoặc weapon
    func animate(repeatForever: Bool = true, completion: @escaping () -> () = {}) {
        stop()
        if let textures = Textures.animation[currentWeapon.rawValue]?[currentState.rawValue] {
            self.textures = textures
            let animate = SKAction.animate(with: textures, timePerFrame: timePerFrame)
            
            // completion được gọi sau khi animate xong 1 lượt
            let completion = SKAction.run(completion)
            let action = SKAction.sequence([animate, completion])
            if repeatForever {
                view.run(.repeatForever(action), withKey: ACTION_KEY_ANIMATE)
            } else {
                view.run(action, withKey: ACTION_KEY_ANIMATE)
            }
        }
    }
    
    // Dừng animation
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
        
        angle += asin(shoulder.distance(to: CGPoint.zero) * view.xScale / location.distance(to: position))
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
        parent.run(SoundController.sharedInstance.HANDGUN_FIRE)
    }
}
