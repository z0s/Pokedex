//
//  UIViewExtension.swift
//  Pokedex
//
//  Created by IT on 9/2/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import UIKit

extension UIViewController {
    
    struct red {
        static let aRed = UIColor(red:1.0, green:0.0, blue:0.0, alpha:1.00)
        static let bRed = UIColor(red: 0.6392, green: 0, blue: 0.0078, alpha: 1.0)
    }
    
    func presentAlert(_ title: String, message: String, actionTitle: String) {
        
        let alertControllerStyle = UIAlertControllerStyle.alert
        let alertView = UIAlertController(title: title, message: message, preferredStyle: alertControllerStyle)
        
        let alertActionStyle = UIAlertActionStyle.default
        let alertActionOK = UIAlertAction(title: actionTitle, style: alertActionStyle, handler: nil)
        
        alertView.addAction(alertActionOK)
        
        DispatchQueue.main.async(execute: {
            self.present(alertView, animated: true, completion: nil)
        })
    }
   
    func showSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        DispatchQueue.main.async(execute: {
            spinner.hidesWhenStopped = true
            spinner.center = self.view.center
            spinner.color = UIColor.orange
            self.view.addSubview(spinner)
            spinner.startAnimating()
        })
        
        return spinner
    }
    

}
extension UIActivityIndicatorView {
    func hide() {
        DispatchQueue.main.async(execute: {
            self.stopAnimating()
            self.removeFromSuperview()
        })
    }
}

