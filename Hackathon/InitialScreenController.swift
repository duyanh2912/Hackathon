//
//  InitialScreenController.swift
//  Hackathon
//
//  Created by Developer on 12/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import UIKit
import SpriteKit
import GameplayKit

class InitialScreenController: UIViewController {
    override var prefersStatusBarHidden: Bool { return true }
    
    deinit {
        print("bye InitialScreen")
    }
    @IBAction func playButtonTapped(_ sender: CustomUIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "gameView")
//        navigationController?.pushViewController(vc!, animated: true)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        print("Go away old view controller!!!")
        appDelegate.window!.rootViewController = vc // (1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        guard let view = self.view as? SKView else { return }
        if let scene = SKScene(fileNamed: "Demo") {
            if UIDevice.current.userInterfaceIdiom == .pad {
                scene.size = CGSize(width: scene.size.width, height: scene.size.width * 1024 / 768)
            } else {
                scene.size = CGSize(width: scene.size.width, height: scene.size.width * 16 / 9)
            }
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            
//            view.showsPhysics = true
        }
    }
}
