//
//  UIViewExtension.swift
//  Pokedex
//
//  Created by IT on 9/2/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import UIKit

extension UIViewController {
    class func gradientLayer() {
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [red.aRed.CGColor as CGColorRef, red.bRed.CGColor as CGColorRef]
        gradient.locations = [0.0, 1.0]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    struct red {
        static let aRed = UIColor(red:1.0, green:0.0, blue:0.0, alpha:1.00)
        static let bRed = UIColor(red: 0.6392, green: 0, blue: 0.0078, alpha: 1.0)
    }
}
