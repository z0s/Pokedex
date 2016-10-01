//
//  ImageDetailViewController.swift
//  Pokedex
//
//  Created by IT on 8/19/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var webView: UIWebView!
    
    let pokemonType = ["Type"]
    let pokemonDescription = ["Description"]
    
    @IBAction func infoButton(_ sender: UIButton) {
        presentAlert("\(pokemon.name.capitalized)", message: "Pokedex number: \(pokemon.id)", actionTitle: "Thanks!")
    }
    var pokemon: Pokemon! {
        didSet {
            PokeAPI.requestPokemonDescriptionForID(pokemon.id.uintValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let url = URL(string: "http://www.pokemon.com/us/pokedex/\(pokemon.id)")
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
     
        tableView.dataSource = self
        tableView.isUserInteractionEnabled = false
        
        title = "\(pokemon.name)"
        descriptionLabel.textColor = UIColor.clear
        typeLabel.textColor = UIColor.black
        
        for type in pokemon.types {
            if typeLabel.text == "" {
                typeLabel.text = type.capitalized
            } else {
                if let typeString = typeLabel.text {
                    typeLabel.text = typeString + ", " + type.capitalized
                }
            }
        }
        
    
        tableView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        
        
        if let image = UIImage(named: "\(pokemon.id)") {
            imageView.image = image
        }
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(descriptionDownloaded), name: NSNotification.Name(rawValue: "PokemonDescriptionDidFinishDownloading"), object: nil)
        
        
    }
    
    func descriptionDownloaded() {
        descriptionLabel.text = pokemon.descriptionString
    }
    
}

extension ImageDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let nougat = 1
        
        return nougat
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return pokemonDescription[0]
        } else {
            return pokemonType[0]
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        if indexPath.section == 0 {
            cell.textLabel?.text = pokemon.descriptionString
            if (cell.textLabel?.text?.isEmpty)! {
                cell.textLabel?.text = "The description is not available."
            }
        }
        
        return cell
    }
    
}
