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
        currentTime = 0;
        let count = SKAction.run {
            self.currentTime = self.currentTime + 1;
        }
        let runTime = SKAction.sequence([count, SKAction.wait(forDuration: 1)])
        self.run(runTime)
        let labelTime = SKLabelNode(fileNamed: "labelTime")
        labelTime?.fontSize = 65;
        labelTime?.color = UIColor.darkGray
        labelTime?.position = CGPoint(x: 0, y: self.size.height)
        labelTime?.text = "Time:  /(self.currentTime)"
        self.camera?.addChild(labelTime!)
    }
}
