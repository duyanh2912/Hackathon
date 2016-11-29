//
//  ExitController.swift
//  Hackathon
//
//  Created by Developer on 11/27/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class ExitController: Controller {
    var view: View!
    weak var parent: SKNode!
    
    required init() {}
    
    func config() {
        view.physicsBody = SKPhysicsBody(rectangleOf: view.size.applying(.init(scaleX: 0.5, y: 0.5)))
        view.physicsBody?.categoryBitMask = BitMasks.EXIT.rawValue
        view.physicsBody?.collisionBitMask = 0
        view.physicsBody?.contactTestBitMask = BitMasks.PLAYER.rawValue
        
        view.handleContact = { 
            other in
            if let winScene = SKScene(fileNamed: "WinScene") {
                guard let scene = self.parent as? SKScene else { return }
                if UIDevice.current.userInterfaceIdiom == .pad {
                    winScene.size = CGSize(width: winScene.size.width, height: winScene.size.width * 1024 / 768)
                }
                winScene.scaleMode = .aspectFill
                scene.view?.presentScene(winScene)
            }
        }
        
        view.configLightningMask(mask: LightMask.DEFAULT.rawValue)
        view.shadowCastBitMask = 0
    }
}
