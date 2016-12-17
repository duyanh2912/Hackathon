//
//  Instruction0.swift
//  Hackathon
//
//  Created by Developer on 12/17/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import UIKit
import Foundation

class Instruction0: InstructionViewController {
    @IBOutlet weak var instructionImage1: UIImageView!
    @IBOutlet weak var instructionImage2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instructionImage1.loadGif(name: "touch")
        instructionImage2.loadGif(name: "win")
    }
}
