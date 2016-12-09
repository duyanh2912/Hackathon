//
//  TriangleLight.swift
//  Hackathon
//
//  Created by Developer on 12/10/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

protocol TriangleLight {
    var isUsingTriangeLight: Bool { get set }
    func configTriangeLight()
}

extension TriangleLight where Self: GameScene {
    func configTriangeLight() {
        guard isUsingTriangeLight == true else { return }
    
        let triangle = SKSpriteNode(texture: Textures.TRIANGLE)
        triangle.setScale(2)
        triangle.position = CGPoint(x: -220, y: 0)
        triangle.zPosition = ZPosition.LIGHT_CONE
        
        playerController.view.addChild(triangle)
        playerController.lightNode.position = playerController.lightNode.position.add(x: 20, y: 0)
    }
}
