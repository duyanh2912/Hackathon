//
//  Instruction3.swift
//  Hackathon
//
//  Created by Developer on 12/18/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import UIKit
import Foundation

class Instruction3: InstructionViewController {
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image1.loadGif(name: "mine")
        image2.loadGif(name: "mine_exploded")
    }
}
