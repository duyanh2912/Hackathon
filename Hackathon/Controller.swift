//
//  Controller.swift
//  Hackathon
//
//  Created by Developer on 11/22/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import SpriteKit
import Foundation

protocol Controller {
    var view: View! { get set }
    weak var parent: SKNode! { get set }
    
    init()
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
    
    init(view: View, parent: SKNode) {
        self.init()
        self.view = view
        self.parent = parent
    }
}
