//
//  Constant.swift
//  Hackathon
//
//  Created by Developer on 11/22/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

let ACTION_KEY_ANIMATE = "animate"

struct BitMasks: OptionSet {
    let rawValue: UInt32
    
    static let WALL = BitMasks(rawValue: 1 << 0)
    static let PLAYER = BitMasks(rawValue: 1 << 1)
    static let ZOMBIE = BitMasks(rawValue: 1 << 2)
    static let HANDGUN = BitMasks(rawValue: 1 << 3)
    static let BULLET = BitMasks(rawValue: 1 << 4)
    static let EXIT = BitMasks(rawValue: 1 << 5)
}

struct Textures {
//    static let FEET_IDLE = SKTexture(image: #imageLiteral(resourceName: "feet_idle"))
    static let BULLET = SKTexture(image: #imageLiteral(resourceName: "bullet"))
    
    static let FEET_IDLE = FEET_RUN[6]
    static let FEET_RUN = SKTextureAtlas(named: "feet_run").toTextures()
    static let FEET_WALK = SKTextureAtlas(named: "feet_walk").toTextures()
    
    static let KNIFE_IDLE = SKTextureAtlas(named: "knife_idle").toTextures()
    static let KNIFE_MOVE = SKTextureAtlas(named: "knife_move").toTextures()
    
    static let HANDGUN_IDLE = SKTextureAtlas(named: "handgun_idle").toTextures()
    static let HANDGUN_MOVE = SKTextureAtlas(named: "handgun_move").toTextures()
    static let HANDGUN_SHOOT = SKTextureAtlas(named: "handgun_shoot").toTextures()
    static let HANDGUN_RELOAD = SKTextureAtlas(named: "handgun_reload").toTextures()
    
    static let animation = [
        "knife": [
            "idle": KNIFE_IDLE,
            "move": KNIFE_MOVE
        ],
        "feet": [
            "run": FEET_RUN,
            "walk": FEET_WALK
        ],
        "handgun": [
            "idle": HANDGUN_IDLE,
            "move": HANDGUN_MOVE,
            "shoot": HANDGUN_SHOOT,
            "reload": HANDGUN_RELOAD
        ]
    ]
}
