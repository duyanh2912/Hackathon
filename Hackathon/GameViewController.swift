//
//  GameViewController.swift
//  Hackathon
//
//  Created by Developer on 11/21/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Random màn chơi
        currentLevel = Int(arc4random_uniform(UInt32(maxLevel))) + 1
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: currentLevelScene) {
                scene.scaleMode = .aspectFit
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            //view.showsPhysics = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
