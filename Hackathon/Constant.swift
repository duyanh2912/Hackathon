//
//  Constant.swift
//  Hackathon
//
//  Created by Developer on 11/22/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

let maxLevel = 4
var currentLevel: Int = 0
var currentLevelScene: String { return "Level\(currentLevel)" }

let ACTION_KEY_ANIMATE = "animate"
let ACTION_KEY_MOVE = "move"

let PLAYER_SPEED: CGFloat = 150

struct Names {
    // Player và những thứ lquan
    static let PLAYER = "player"
    static let FEET = "feet"
    
    // Các thành phần cần thiết của mỗi bàn
    static let BACKGROUND = "background"
    static let WALL = "wall"
    static let EXIT = "exit"
    
    // Các loại power up
    static let HANDGUN = "handgun"
    static let STUNT_POWER_UP = "stunt_power_up"
    static let MINE_POWER_UP = "mine_power_up"
    
    // Các loại trap
    static let TRAP = "trap"
    static let MINE_TRAP = "mine_trap"
    static let MINE_RANDOM = "mine_random"
    
    // Các loại zombie
    static let ZOMBIE = "zombie"
    static let SMART_ZOMBIE = "smart_zombie"
    static let STATUE_ZOMBIE = "statue_zombie"
    static let SUPER_ZOMBIE = "super_zombie"
    static let EYE_RAY = "eye_ray"
}

struct BitMasks {
    static let zero: UInt32 = 0
    static let WALL: UInt32 = 1 << 0
    static let PLAYER: UInt32 = 1 << 1
    static let ZOMBIE: UInt32 = 1 << 2
    static let HANDGUN: UInt32 = 1 << 3
    static let BULLET: UInt32 = 1 << 4
    static let EXIT: UInt32 = 1 << 5
    static let STATUE: UInt32 = 1 << 6
    static let GIFT: UInt32 = 1 << 7
    static let TRAP: UInt32 = 1 << 8
    static let BOOM: UInt32 = 1 << 9
    static let BOOMFIRST: UInt32 = 1 << 10
    static let EYE_RAY: UInt32 = 1 << 11
    static let BLAST: UInt32 = 1 << 12
}

struct LightMask {
    static let DEFAULT: UInt32 = 1 << 0
}

struct Textures {
//    static let FEET_IDLE = SKTexture(image: #imageLiteral(resourceName: "feet_idle"))
    static let BULLET = SKTexture(image: #imageLiteral(resourceName: "bullet"))
    static let TRIANGLE = SKTexture(image: #imageLiteral(resourceName: "triangle"))
    static let SON_TUNG = SKTexture(image: #imageLiteral(resourceName: "son_tung"))
    static let RAY = SKTexture(image: #imageLiteral(resourceName: "ray"))
    static let MINE = SKTexture(imageNamed: "mine")
    
    static let FEET_IDLE = FEET_WALK[6]
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

struct ZPosition {
    static let PLAYER: CGFloat = 10
    static let FEET: CGFloat = -0.1  // child của player
    static let LIGHT_CONE: CGFloat = -1 // child của player
    
    static let ZOMBIE: CGFloat = 1
    static let EYE_RAY: CGFloat = 10 // child của zombie
    
    static let FOOTPRINT: CGFloat = 9.5
    static let TIME: CGFloat = 100
    static let BACKGROUND: CGFloat = -10
    static let WALL: CGFloat = 0
    static let EXIT: CGFloat = 0
    
    static let STUNT_POWER_UP: CGFloat = 1
    static let MINE_POWER_UP: CGFloat = 0
    
    static let MINE_TRAP: CGFloat = 0
    static let TRAP: CGFloat = 1
    static let BLAST: CGFloat = 9.5

}
