//
//  ShakingLogo.swift
//  Juicy
//
//  Created by Will Morphy on 10/12/18.
//  Copyright © 2018 Will Morphy. All rights reserved.
//


import UIKit

class ShakingLogo: UIImageView{
    
    func shake () {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.2
        animation.repeatCount = 100
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 4, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 4, y: self.center.y))
        
        self.layer.add(animation, forKey: "position")
    }
}

