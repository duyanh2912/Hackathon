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
    @IBInspectable var blendMode: CGBlendMode! {
        get { return self.blendMode }
        set { self.blendMode = newValue }
    }
    
    @IBInspectable var blendAlpha: CGFloat! {
        didSet{
            self.blend()
        }
    }
    
    @IBInspectable var blendColor: UIColor! {
        didSet {
            self.blend()
        }
    }
    
    func blend() {
        guard var image = self.image else { return }
        UIGraphicsBeginImageContextWithOptions(image.size, true, 0)
        
        image.draw(at: .zero)
        
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        blendColor.withAlphaComponent(blendAlpha ?? 0.5).setFill()
        UIRectFillUsingBlendMode(rect, .multiply)
        
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}
