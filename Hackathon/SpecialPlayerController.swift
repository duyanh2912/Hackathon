//
//  SpecialPlayerController.swift
//  Hackathon
//
//  Created by Developer on 12/10/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class SpecialPlayerController: PlayerController {
    override func animate(repeatForever: Bool, completion: @escaping () -> ()) {}
    override func configFeet() {}
    override func configGameOver() {
        self.gameOver = { [unowned parent = self.parent as! GameScene] in
            SepTungGameOverScene.present(view: parent.view!)
        }
    }
}
