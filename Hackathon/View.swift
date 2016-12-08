//
//  View.swift
//  Hackathon
//
//  Created by Developer on 11/22/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import UIKit
import SpriteKit
import Foundation

typealias HandleContact = (_: View) -> ()

class View: SKSpriteNode {
    var handleContact: HandleContact?
}

