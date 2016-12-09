//
//  GameoverScene.swift
//  Session1
//
//  Created by Developer on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class GameoverScene: SKScene {
    var replayLabel: SKLabelNode!
    
    deinit {
        print("bye GameOver Scene")
    }
    
    override func didMove(to view: SKView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [unowned self] in
//            let audio = SKAudioNode(fileNamed: "game_over")
//            self.addChild(audio)
//            audio.run(.play())
            self.run(SoundController.sharedInstance.GAME_OVER)
        }
       
        let gameoverLabel = childNode(withName: "gameoverLabel") as! SKLabelNode
        gameoverLabel.position = frame.center()
        gameoverLabel.alpha = 0
        
        
        replayLabel = SKLabelNode(text: "Replay")
        replayLabel.position = gameoverLabel.position.add(x: 0, y: -50)
        replayLabel.fontSize = 40
        replayLabel.name = "replayLabel"
        replayLabel.alpha = 0
        addChild(replayLabel)
        
        gameoverLabel.run(SKAction.fadeAlpha(to: 1, duration: 1)) { [unowned self] in
            self.replayLabel.run(.fadeAlpha(to: 1, duration: 0.4)) {
                self.replayLabel.run(.repeatForever(.sequence([.fadeAlpha(to: 0.2, duration: 0.4),
                                                               .fadeAlpha(to: 1, duration: 0.4)
                    ])))
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        if nodes(at: location).contains(replayLabel) {
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
    
    static func present(view: SKView) {
        if let scene = SKScene(fileNamed: "GameoverScene") {
            if UIDevice.current.userInterfaceIdiom == .pad {
                scene.size = CGSize(width: scene.size.width, height: scene.size.width * 1024 / 768)
            }
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
        }
    }
}
