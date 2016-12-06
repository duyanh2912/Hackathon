//
//  CGSize.swift
//  Hackathon
//
//  Created by Developer on 12/6/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation
import SpriteKit

extension CGSize {
    func scale(by factor: CGFloat) -> CGSize {
        let width = self.width * factor
        let height = self.height * factor
        return CGSize(width: width, height: height)
    }
}
