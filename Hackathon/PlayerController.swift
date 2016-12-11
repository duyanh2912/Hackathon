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
    var SPEED: CGFloat = PLAYER_SPEED
    var touchLocation: CGPoint?
    var timePerFrame: Double = 1/20  //Animation
    
    // CHILDREN
    var lightNode = SKLightNode()
    var feetController: FeetController?
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
    
    // POWER UPS
    var numberOfMines: Int = 0 {
        didSet {
            (parent as? GameScene)?.mineLabel.text = "MINE: \(numberOfMines)"
        }
    }
    
    // ACTION
    var move: (() -> ())!
    var gameOver: (() -> ())!
    
    // FUNCTIONS
    
    // Dùng hàm set() thay cho init()
    override init(view: View, parent: SKNode) {
        super.init(view: view, parent: parent)
    }
    
    // Chỉnh physics + lightning
    func config() {
        configFeet()
        view.zPosition = ZPosition.PLAYER
        
        view.physicsBody = SKPhysicsBody(circleOfRadius: view.size.height / 2 * 0.7)
        view.physicsBody?.restitution = 0
        view.physicsBody?.allowsRotation = true
        
        view.physicsBody?.categoryBitMask = BitMasks.PLAYER
        view.physicsBody?.collisionBitMask = BitMasks.WALL | BitMasks.STATUE
        view.physicsBody?.contactTestBitMask = BitMasks.ZOMBIE
    
        configHandleContact()
        animate()
        
        view.addChild(lightNode)
        lightNode.categoryBitMask = 1
        lightNode.falloff = 2
        
        configMove()
        configGameOver()
    }
    
    func configGameOver() {
        gameOver = { [unowned parent = self.parent as! GameScene] in
            GameoverScene.present(view: parent.view!)
        }
    }
    
    func configFeet() {
        let feet = View(texture: Textures.FEET_IDLE)
        self.feetController = FeetController(
            view: feet,
            parent: parent
        )
        feetController?.timePerFrame = self.timePerFrame
        feetController?.config(moveType: .walk)
        view.addChild(feet)
    }
    
    func configHandleContact() {
        view.handleContact = { [unowned self, unowned parent = self.parent as! GameScene] other in
            if other.physicsBody?.categoryBitMask == BitMasks.ZOMBIE {
                self.gameOver()
            }
            if other.physicsBody?.categoryBitMask == BitMasks.TRAP {
                self.stopMoving(duration: 2)
            }
            if other.physicsBody?.categoryBitMask == BitMasks.BLAST {
                self.lightNode.move(toParent: self.parent)
                self.feetController = nil
                self.view.removeFromParent()
                self.parent.run(.wait(forDuration: 1)) {
                    self.gameOver()
                }
            }
        }
    }
    
    // Vì PlayerController là singleton nên mỗi lần chơi lại phải reset
    func reset() {
        self.touchLocation = nil
        self.currentState = .idle
        self.currentWeapon = .knife
    }
    
    // Hàm move() đc gọi trong update của GameScene
    func configMove() {
        move = {
            // Nếu người chơi chưa chạm tay vào màn hình (touchLocation == nil) thì return luôn
            guard let destination = self.touchLocation else { return }
            let dx = destination.x - self.position.x
            let dy = destination.y - self.position.y
            
            // Khi player đến đủ gần touchLocation thì dừng việc chuyển động lại
            guard abs(dx) > self.width / 8 || abs(dy) > self.height / 8  else {
                self.view.physicsBody?.isResting = true
                if self.currentState == .move {
                    self.currentState = .idle
                    self.animate()
                }
                self.feetController?.stop()
                return
            }
            
            // Xoay player về phía touchLocation
            let angle = CGFloat.angleHeadTowardDestination(current: self.position, destination: destination, spriteAngle: 0)
            self.view.zRotation = angle
            
            // Gắn vector vận tốc cho player
            var vector = CGVector(dx: dx, dy: dy)
            vector = vector.scale(by: self.SPEED / destination.distance(to: self.position))
            self.view.physicsBody?.velocity = vector
            self.view.physicsBody?.angularVelocity = 0
            
            if self.currentState == .idle {
                self.currentState = .move
                self.animate()
            }
            
            // Nếu feet chưa animate thì cho nó animate
            if self.feetController?.isAnimating == false {
                self.feetController?.animate()
            }
        }
    }
    
    // Gọi hàm nếu muốn player dừng lại trong 1 khoảng thời gian nào đó
    func stopMoving(duration: Double) {
        view.physicsBody?.isDynamic = false
        move = {}
        self.view.run(SKAction.wait(forDuration: duration)){[unowned self] in
            self.view.physicsBody?.isDynamic = true
            self.configMove()
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
    
    func throwMine() {
        guard numberOfMines > 0 else {
            return
        }
        view.physicsBody?.isResting = true
        touchLocation = position
        numberOfMines -= 1
        let boom = MineTrapController(parent: parent)
        boom.config()
        boom.view.position = view.position.add(
            x: 75 * cos(view.zRotation),
            y: 75 * sin(view.zRotation))
        parent.addChild(boom.view)
    }
}
