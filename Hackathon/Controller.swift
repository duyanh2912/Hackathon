//
//  Controller.swift
//  Hackathon
//
//  Created by Developer on 11/22/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

class Controller {
    var view: View!
    weak var parent: SKNode!
    
    init(view: View, parent: SKNode) {
        self.view = view
        self.parent = parent
    }
}

extension Controller {
    var position: CGPoint {
        return view.position
    }
    var height: CGFloat {
        return view.size.height
    }
    var width: CGFloat {
        return view.size.width
    }
  
}
