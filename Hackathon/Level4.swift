//
//  Level4.swift
//  Hackathon
//
//  Created by Developer on 12/10/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import AVFoundation
import SpriteKit
import Foundation

class Level4: GameScene {
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        for zombie in allZombies {
            zombie.audio = SKAudioNode(url: Bundle.main.url(forResource: "tha_thu", withExtension: "wav")!)
            zombie.configSound()
            zombie.view.shadowCastBitMask = 0
        }
    }
    
    override func configStatueZombies() {
        for node in self[Names.STATUE_ZOMBIE] {
            let zombie = StatueZombieController(view: node as! View, parent: self)
            zombie.view.colorBlendFactor = 0
            zombie.config()
            statueZombieControllers.append(zombie)
        }
    }
    
    override func configPlayer() {
        let player = self.childNode(withName: Names.PLAYER) as! View
        playerController = SpecialPlayerController(view: player, parent: self)
        PlayerController.instance = playerController
        playerController.config()
        self.listener = player
        playerController.lightNode.falloff = 2
    }
    
    override func configMusic() {
        func loadMusic(path: URL) {
            GameScene.audioPlayer = try! AVAudioPlayer(contentsOf: path)
            GameScene.audioPlayer?.numberOfLoops = -1
            GameScene.audioPlayer?.currentTime = 2
            GameScene.audioPlayer?.play()
        }
        
        if let path = Bundle.main.url(forResource: "Em Cua Ngay Hom Qua - Son Tung M TP", withExtension: "mp3") {
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
}
