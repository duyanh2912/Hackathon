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
