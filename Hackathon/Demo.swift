//
//  Demo.swift
//  Hackathon
//
//  Created by Developer on 12/13/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class Demo: GameScene {
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        mineLabel.isHidden = true
        timeLabel.isHidden = true
    }
    
//    override func configPlayer() {
//        super.configPlayer()
//        playerController.move = { [unowned self] in
//            self.playerController.view.zRotation += CGFloat.pi / 2
//        }
//        
//        let path = UIBezierPath()
//        path.move(to: .zero)
//        
//        let center = CGPoint.init(x: 0, y: -250)
//        path.addArc(withCenter: center,
//                    radius: 250,
//                    startAngle: CGFloat.pi / 2,
//                    endAngle: CGFloat.pi * 2 + CGFloat.pi / 2,
//                    clockwise: true)
//        playerController.view.run(.repeatForever(.follow(path.cgPath, asOffset: true, orientToPath: true, speed: playerController.SPEED)))
//        
//        playerController.feetController?.animate()
//
//    }
    
    override func configPlayer() {
        let player = self.childNode(withName: Names.PLAYER) as! View
        playerController = DemoPlayerController(view: player, parent: self)
        PlayerController.instance = playerController
        playerController.config()
        self.listener = player
    }
    
    override func configZombies() {
        let index = Int(arc4random_uniform(UInt32(self[Names.ZOMBIE].count)))
        self[Names.ZOMBIE][index].name = Names.SMART_ZOMBIE
        super.configZombies()
    }
}
