//
//  UIViewExtension.swift
//  Mesa
//
//  Created by Vibes on 4/27/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import Foundation
import UIKit

var greenColor = UIColor(red:0.25, green:0.78, blue:0.14, alpha:1.0).cgColor
var greenColorUI = UIColor(red:0.25, green:0.78, blue:0.14, alpha:1.0)
var gray3 = UIColor.gray.withAlphaComponent(0.3)


extension UIView {
    
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    func greenShadow() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = greenColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 0.05 * frame.width
        
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = false
    }
    
    func shadow() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 0.02 * frame.width
        
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = false
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-10.0, 10.0, -10.0, 10.0, -5.0, 5.0, -2.5, 2.5, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    func setGrayBorder() {
        
        self.borderColor = gray3
        self.borderWidth = 1
        self.cornerRadius = 4
    }
    
    func fadeOut(completion : () -> Void) {
        
        UIView.animate(withDuration: 0.2) { 
            self.alpha = 0
        }
        
        completion()
    }
    
    func disappear() {
        
        self.subviews.forEach { (view) in
            view.alpha = 0
        }
    }
    
    func fadeIn() {
        
        self.subviews.forEach { (view) in
            UIView.animate(withDuration: 0.3, animations: { 
                view.alpha = 1
            })
        }
    }
    
    func fadeSelfIn() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        })
    }
    
}


