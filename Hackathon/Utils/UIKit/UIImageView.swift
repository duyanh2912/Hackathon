//
//  UIImageView.swift
//  Hackathon
//
//  Created by Developer on 12/15/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import UIKit
import Foundation

@available(iOS 10.0, *)
@IBDesignable
class CustomUIImageView: UIImageView {
    @IBInspectable var blendMode: Int32 = 1 {
        didSet {
            self.blend()
        }
    }
    
    @IBInspectable var blendAlpha: CGFloat = 0 
    
    @IBInspectable var blendColor: UIColor = .clear
    
    func blend() {
        guard var image = self.image else { return }
        UIGraphicsBeginImageContextWithOptions(image.size, true, 0)
        
        image.draw(at: .zero)
        
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        blendColor.withAlphaComponent(blendAlpha).setFill()
        UIRectFillUsingBlendMode(rect, CGBlendMode.init(rawValue: blendMode) ?? .multiply)
        
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}

