//
//  WinScene.swift
//  Hackathon
//
//  Created by Phan Văn Đa on 11/27/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class WinScene: SKScene {
    var finalTime: Int!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        
        for node in nodes(at: location) {
            if node.name == "replay" {
                currentLevel = (currentLevel == maxLevel) ? 1 : (currentLevel + 1)
                
                if let view = self.view {
                    // Load the SKScene from 'GameScene.sks'
                    if let scene = SKScene(fileNamed: currentLevelScene) {
                        // Set the scale mode to scale to fit the window
                        scene.scaleMode = .aspectFit
                        
                        // Present the scene
                        view.presentScene(scene, transition: .doorsOpenHorizontal(withDuration: 1))
                    }
                }
            }
        }
        for node in nodes(at: location) {
            if node.name == "score" {
                let label = node as! SKLabelNode
                label.text = "Score: /(finalTime)"
                
            }
        }
    }
    static func present(view: SKView) {
        if let winScene = SKScene(fileNamed: "WinScene") {
            if UIDevice.current.userInterfaceIdiom == .pad {
                winScene.size = CGSize(width: winScene.size.width, height: winScene.size.width * 1024 / 768)
            }
            winScene.scaleMode = .aspectFill
            (winScene as! WinScene).finalTime = (view.scene as! Timer).currentTime
            view.presentScene(winScene)
        }
    }
}
