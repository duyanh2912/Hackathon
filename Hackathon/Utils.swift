//
//  Utils.swift
//  Hackathon
//
//  Created by Developer on 11/22/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

extension CGPoint {
    func distance(to other: CGPoint) -> CGFloat {
        let dx = other.x - self.x
        let dy = other.y - self.y
        
        return sqrt(dx * dx + dy * dy)
    }
    
    func add(x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + x, y: self.y + y)
    }
}

extension CGFloat {
    static func angleHeadTowardDestination(current position: CGPoint, destination: CGPoint, spriteAngle: CGFloat) -> CGFloat{
        let dx = destination.x - position.x
        let dy = destination.y - position.y
        
        var angle = atan(dy / dx)
        angle = (dx < 0) ? (angle + CGFloat.pi) : angle
        return angle - spriteAngle
    }
}

extension CGVector {
    mutating func scale(by factor: CGFloat) {
        self.dx = self.dx * factor
        self.dy = self.dy * factor
    }
}

extension CGRect {
    func middlePoint() -> CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
}

extension SKTextureAtlas {
    func toTextures() -> [SKTexture] {
        var textures = [SKTexture]()
        for name in self.textureNames.sorted() {
            textures.append(self.textureNamed(name))
        }
        return textures
    }
}
