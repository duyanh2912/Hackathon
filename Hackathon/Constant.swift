//
//  Constant.swift
//  Hackathon
//
//  Created by Developer on 11/22/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation

struct BitMasks: OptionSet {
    let rawValue: UInt32

    static let WALL = BitMasks(rawValue: 1 << 0)
    static let PLAYER = BitMasks(rawValue: 1 << 1)
    static let ZOMBIE = BitMasks(rawValue: 1 << 2)
}
