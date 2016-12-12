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
    var timeLabel: SKLabelNode! { get set }
    
    func configTimer()
}
extension Timer where Self: GameScene{
    func configTimer(){
        // Có 100 giây để chơi hết bài
        currentTime = 100
        
        // labelTime
        timeLabel = SKLabelNode()
        timeLabel.fontSize = 65
        timeLabel.fontName = "Papyrus"
        timeLabel.color = UIColor.darkGray
        timeLabel.verticalAlignmentMode = .top
        timeLabel.position = CGPoint(x: 0, y: self.size.height / 2 - 50)
        timeLabel.text = "Time: \(self.currentTime!)"
        timeLabel.zPosition = ZPosition.TIME
        
        // Add vào camera để labelTime luôn ở trên màn hình
        self.camera?.addChild(timeLabel)
        
        // Cứ mỗi giây time giảm 1
        let count = SKAction.run { [unowned self] in
            if self.currentTime == 0 {
                GameoverScene.present(view: self.view!)
            }
            
            self.currentTime = self.currentTime - 1;
            self.timeLabel.text = "Time: \(self.currentTime!)"
        }
        let runTime = SKAction.sequence([SKAction.wait(forDuration: 1), count])
        self.run(SKAction.repeatForever(runTime))
        
    }
}
