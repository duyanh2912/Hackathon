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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        
        for node in nodes(at: location) {
            if node.name == "replay" {
                currentLevel = (currentLevel == 2) ? 1 : (currentLevel + 1)
                
                if let view = self.view {
                    // Load the SKScene from 'GameScene.sks'
                    if let scene = SKScene(fileNamed: currentLevelScene) {
                        // Set the scale mode to scale to fit the window
                        scene.scaleMode = .fill
                        
                        // Present the scene
                        view.presentScene(scene, transition: .doorsOpenHorizontal(withDuration: 1))
                    }
                }
            }
        }
    }
}
