//
//  ViewController.swift
//  pokedex
//
//  Created by IT on 8/19/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    

    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
        self.title = "Pokemon"
        gradientLayer()

        var pokemon: Pokemon! {
            didSet {
                if let pokemon = pokemon, image = UIImage(contentsOfFile: pokemon.urlString!) {
                    imageView.image = image
                }
            }
        }

       // (named: "\(pokemon.id)")
    
        
    }
    private func gradientLayer() {
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [red.aRed.CGColor as CGColorRef, red.bRed.CGColor as CGColorRef]
        gradient.locations = [0.0, 1.0]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
    }

}

