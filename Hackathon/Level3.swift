//
//  Level3.swift
//  Hackathon
//
//  Created by Developer on 12/2/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class Level3: Level1, TriangleLight {
    var isUsingTriangeLight: Bool = true
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        configTriangeLight()
    }
    
    override func configZombies() {
        for node in self[Names.ZOMBIE] {
            let rand = arc4random_uniform(1)
            if rand == 0 {
                node.name = Names.SMART_ZOMBIE
            } else if rand == 1 {
                //node.name = Names.SUPER_ZOMBIE
            }
        }
        super.configZombies()
    }
    
//    override func configCamera() {
//        super.configCamera()
//        self.camera = nil
//    }
}

