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

class GameScene: SKScene, SKPhysicsContactDelegate, SmartZombies, Timer {
    // Số mìn player đang giữ
    var mineLabel: SKLabelNode!
    
    // Timer phục vụ tính điểm
    var currentTime: Int! = 0
    var timeLabel: SKLabelNode!
    
    // Sound Controller cho tiếng bắn súng v.v...
    let soundController = SoundController.sharedInstance
    
    // Player
    var playerController: PlayerController!
    
    // Các loại zombie
    var allZombies: [ZombieController] {
        get {
            var array = [ZombieController]()
            array += zombieControllers
            array += statueZombieControllers as [ZombieController]
            array += superZombieControllers as [ZombieController]
            array += smartZombieControllers as [ZombieController]
            return array
        }
    }
    var zombieControllers = [ZombieController]()
    var statueZombieControllers = [StatueZombieController]()
    var superZombieControllers = [SuperZombieController]()
    
    // Tường
    var wallControllers = [WallController]()
    
    // Nhạc nền, để static thì ở màn hình Game Over vẫn có nhạc
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
        configPhysics()
        configBackground()
        configWalls()
        configPathFinder()
        configPlayer()
        configZombies()
        configGuns()
        configExit()
        configSmartZombies()
        configStatueZombies()
        configSuperZombies()
        configCamera()
        configTimer()
        configStuntPowerUp()
        configMineRandom()
        configTraps()
        configMinePowerUp()
        configDropLabel()
        configMineTrap()
    }
    
    func configMineRandom() {
        for node in self[Names.MINE_RANDOM] {
            if arc4random_uniform(2) == 0 {
                node.name = Names.MINE_TRAP
            } else {
                node.name = Names.MINE_POWER_UP
            }
        }
    }
    
    func configMineTrap() {
        for node in self[Names.MINE_TRAP] {
            let controller = MineTrapController(view: node as! View, parent: self)
            controller.config()
        }
    }
    
    func configBackground() {
        guard let node = self.childNode(withName: Names.BACKGROUND) as? SKSpriteNode else { return }
        node.configLightningMask(mask: LightMask.DEFAULT)
        node.shadowCastBitMask = 0
        node.zPosition = ZPosition.BACKGROUND
    }
    func configMusic() {
        func loadMusic(path: URL) {
            GameScene.audioPlayer = try! AVAudioPlayer(contentsOf: path)
            GameScene.audioPlayer?.volume = 0.75
            GameScene.audioPlayer?.numberOfLoops = -1
            GameScene.audioPlayer?.play()
        }
        
        if let path = Bundle.main.url(forResource: "background", withExtension: "mp3") {
            print("music")
            if let audio = GameScene.audioPlayer {
                if audio.url != path {
                    loadMusic(path: path)
                }
            } else {
                loadMusic(path: path)
            }
        }
    }
    
    func configExit() {
        if let exit = childNode(withName: Names.EXIT) as? View {
            let controller = ExitController(view: exit, parent: self)
            controller.config()
        }
    }
    
    func configZombies() {
        for node in children {
            if node.name == Names.ZOMBIE {
                let zombie = ZombieController(view: node as! View, parent: self)
                zombie.config()
                zombieControllers.append(zombie)
            }
        }
    }
    func configStuntPowerUp(){
        for node in children {
            if node.name == Names.STUNT_POWER_UP {
                let gift = StuntPowerUpController(view: node as! View, parent: self)
                gift.config()
            }
        }
    }
    func configMinePowerUp() {
        for node in children {
            if node.name == Names.MINE_POWER_UP {
                let boom = MinePowerUpController(view: node as! View, parent: self)
                boom.config()
            }
        }
    }
    func configTraps() {
        for node in children {
            if node.name == Names.TRAP {
                let trap = TrapController(view: node as! View, parent: self)
                trap.config()
            }
        }
    }
    func configStatueZombies() {
        for node in self[Names.STATUE_ZOMBIE] {
            let zombie = StatueZombieController(view: node as! View, parent: self)
            zombie.config()
            statueZombieControllers.append(zombie)
        }
    }
    
    func configSuperZombies() {
        for node in self[Names.SUPER_ZOMBIE] {
            let zombie = SuperZombieController(view: node as! View, parent: self)
            zombie.config()
            superZombieControllers.append(zombie)
        }
    }
    
    
    func configPlayer() {
        let player = self.childNode(withName: Names.PLAYER) as! View
        playerController = PlayerController(view: player, parent: self)
        PlayerController.instance = playerController
        playerController.config()
//                playerController.lightNode.isEnabled = false
        self.listener = player
    }
    
    func configWalls() {
        self.enumerateChildNodes(withName: Names.WALL) { [unowned self]
            (node, stop) in
            let controller = WallController(view: node as! View, parent: self)
            controller.config()
            self.wallControllers.append(controller)
        }
    }
    
    func configPhysics() {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = .zero
    }
    
    func configDropLabel() {
        mineLabel = SKLabelNode()
        mineLabel.name = "DropBoom"
        mineLabel.text = "Mine: \(playerController.numberOfMines)"
        mineLabel.fontSize = 90 * self.size.width / 1080
        mineLabel.fontName = "Papyrus"
        mineLabel.color = UIColor.darkGray
        mineLabel.verticalAlignmentMode = .bottom
        mineLabel.horizontalAlignmentMode = .left
        mineLabel.position = CGPoint(x: -self.size.width / 2, y: -self.size.height / 2).add(x: 20, y: 20)
        mineLabel.zPosition = ZPosition.TIME
        self.camera?.addChild(mineLabel)
    }
    
    func configCamera() {
               // Chỉnh kích thước của GameScene để camera luôn vừa với màn hình (không bị chòi ra ngoài)
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.size = CGSize(width: size.width, height: size.width * 4 / 3)
        } else {
            self.size = CGSize(width: size.width, height: size.width * 16 / 9)
        }
        
        // Chỉnh scale để kích thước camera ở các bàn chơi là cố định
        let camera = SKCameraNode()
        camera.setScale(540 / size.width)
        
        // Nếu là iPhone thì cho camera to ra để dễ chơi hơn
        if UIDevice.current.userInterfaceIdiom == .phone {
            camera.setScale(camera.xScale / 0.75)
        }
        
        // Đặt camera của GameScene là SKCameraNode vừa tạo
        self.addChild(camera)
        self.camera = camera
        
    }
    
    func configGuns() {
        for node in children {
            if node.name == Names.HANDGUN {
                let gun = node as! View
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
        // Hàm move được gọi liên tục để player và zombie di chuyển nuột =))
        PlayerController.instance.move()
        for zombie in allZombies { zombie.move() }
        
        // Cho camera đi theo player
        camera?.position = PlayerController.instance.position
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Smart Zombie update đường đi 0.05s 1 lần
        guard lastUpdate != nil else {
            lastUpdate = currentTime
            zombiesPathUpdate()
            return
        }
        if currentTime - lastUpdate! > 0.05 {
            lastUpdate = currentTime
            zombiesPathUpdate()
            
            for node in self["\(Names.SUPER_ZOMBIE)/\(Names.EYE_RAY)"] {
                if node.intersects(playerController.view) {
                    playerController.SPEED = playerController.INITIAL_SPEED * 3 / 4
                    return
                }
            }
            playerController.SPEED = playerController.INITIAL_SPEED
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        for node in nodes(at: location) {
            // Nếu có súng thì chạm vào zombie là bắn
            if playerController.currentWeapon != .knife {
                if node.physicsBody?.categoryBitMask == BitMasks.ZOMBIE {
                    playerController.shoot(at: location)
                    return
                }
            }
            
            if node === mineLabel {
                playerController.throwMine()
                return
            }
        }
        // update touchLocation của PlayerController để hàm move di chuyển tới điểm chạm mới
        PlayerController.instance.touchLocation = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            // update touchLocation của PlayerController để hàm move di chuyển tới điểm chạm mới
            PlayerController.instance.touchLocation = location
        }
    }
}
