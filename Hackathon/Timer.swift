//
//  File.swift
//  Hackathon
//
//  Created by Phan Văn Đa on 12/9/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation
import SpriteKit
protocol Timer {
    var currentTime: Int!{
        get set
    }
    func configTimer()
}
extension Timer where Self: GameScene{
    func configTimer(){
        currentTime = 100
        let labelTime = SKLabelNode()
        labelTime.fontSize = 65;
        labelTime.fontName = "Arial"
        labelTime.color = UIColor.darkGray
        labelTime.verticalAlignmentMode = .top
        labelTime.position = CGPoint(x: 0, y: self.size.height / 2 - 50)
        labelTime.text = "Time: \(self.currentTime!)"
        labelTime.zPosition = 10
        self.camera?.addChild(labelTime)
        
        let count = SKAction.run { [unowned self] in
            if self.currentTime == 0 {
                GameoverScene.present(view: self.view!)
            }
            
            self.currentTime = self.currentTime - 1;
            labelTime.text = "Time: \(self.currentTime!)"
        }
        let runTime = SKAction.sequence([SKAction.wait(forDuration: 3), count])
        self.run(SKAction.repeatForever(runTime))
        
    }
}
