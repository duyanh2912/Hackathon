//
//  DemoPlayerController.swift
//  Hackathon
//
//  Created by Developer on 12/13/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation
import GameplayKit

class DemoPlayerController: PlayerController {
    var pathNodes: [CGPoint]!
    var currentTargetNodeIndex: Int = 0
    
    override func configMove() {
        pathNodes = PathFinder.pathNodes(start: view.position, destination: parent.childNode(withName: Names.EXIT)!.position, graph: PathFinder.instance.graph)

        move = {
            guard self.view != nil else { return }
            guard self.currentTargetNodeIndex < self.pathNodes.count else {
                self.view.physicsBody?.isResting = true
                return
            }
            
            let dx = self.pathNodes[self.currentTargetNodeIndex].x - self.position.x
            let dy = self.pathNodes[self.currentTargetNodeIndex].y - self.position.y
            if !(abs(dx) > self.width / 8 || abs(dy) > self.height / 8) {
                self.currentTargetNodeIndex += 1
            }
            
            self.view.headToward(self.pathNodes[self.currentTargetNodeIndex], spriteAngle: 0, speed: self.SPEED)
            
        }
        
        if self.feetController?.isAnimating == false {
            self.feetController?.animate()
        }
    }
    
    override func configWin() {
        win = { [unowned view = (self.parent as! GameScene).view!] in
            if let scene = SKScene(fileNamed: "Demo") {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    scene.size = CGSize(width: scene.size.width, height: scene.size.width * 1024 / 768)
                } else {
                    scene.size = CGSize(width: scene.size.width, height: scene.size.width * 16 / 9)
                }
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
        }
    }
    
    override func configGameOver() {
        gameOver = win
    }
}
