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
        
        // Xem triangle trong assets để biết thêm chi tiết =))
        let triangle = SKSpriteNode(texture: Textures.TRIANGLE)
        triangle.setScale(2)
        triangle.position = CGPoint(x: -220, y: 0)
        triangle.zPosition = ZPosition.LIGHT_CONE
        triangle.name = "light_cone"
        
        playerController.view.addChild(triangle)
        
        // dịch light node lên trên 1 tẹo cho sáng hơn
        playerController.lightNode.position = playerController.lightNode.position.add(x: 20, y: 0)
    }
}
