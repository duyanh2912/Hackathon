//
//  Utils.swift
//  Hackathon
//
//  Created by Developer on 11/22/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation
import GameplayKit

extension SKNode {
    func configPhysicsMask(category: UInt32, collision: UInt32, contact: UInt32) {
        physicsBody?.categoryBitMask = category
        physicsBody?.collisionBitMask = collision
        physicsBody?.contactTestBitMask = contact
    }
}

extension GKGraphNode2D {
    func toCGPoint() -> CGPoint {
        return CGPoint(x: CGFloat(self.position.x), y: CGFloat(self.position.y))
    }
}

extension SKSpriteNode {
    func configLightningMask(mask: UInt32) {
        self.lightingBitMask = mask
        self.shadowedBitMask = mask
        self.shadowCastBitMask = mask
    }
    
    var height: CGFloat { return self.size.height }
    var width: CGFloat { return self.size.width }
    
    func headToward(_ destination: CGPoint, spriteAngle: CGFloat, speed: CGFloat) {
        let angle = CGFloat.angleHeadTowardDestination(current: self.position, destination: destination, spriteAngle: spriteAngle)
        self.zRotation = angle
        
        let vector = CGVector(dx: destination.x - self.position.x, dy: destination.y - self.position.y).scale(by: speed / destination.distance(to: self.position))
        self.physicsBody?.velocity = vector
        self.physicsBody?.angularVelocity = 0
    }
}

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
    func scale(by factor: CGFloat) -> CGVector {
        let dx = self.dx * factor
        let dy = self.dy * factor
        return CGVector(dx: dx, dy: dy)
    }
    
    func subtract(by vector: CGVector) -> CGVector {
        return CGVector(dx: self.dx - vector.dx, dy: self.dy - vector.dy)
    }
}

extension CGSize {
    func scale(by factor: CGFloat) -> CGSize {
        let width = self.width * factor
        let height = self.height * factor
        return CGSize(width: width, height: height)
    }
}

extension CGRect {
    func center() -> CGPoint {
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
