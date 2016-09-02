//
//  CollectionViewController.swift
//  pokedex
//
//  Created by IT on 8/22/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var pokemonArray = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Pokedex"
        gradientLayer()
    
        // Register cell classes
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        pokemonArray = PokemonDataProvider.fetchPokemon()
    }
    private func gradientLayer() {
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [red.aRed.CGColor as CGColorRef, red.bRed.CGColor as CGColorRef]
        gradient.locations = [0.0, 1.0]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
    }
}

    // MARK: UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        
        let pokemon = pokemonArray[indexPath.row]
        cell.pokemon = pokemon
        
        // Configure the cell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return pokemonArray.count
    }
    
    
}
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
// MARK: UICollectionViewDelegate
extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailController: ImageDetailViewController = storyboard.instantiateViewControllerWithIdentifier("ImageDetail") as! ImageDetailViewController
        self.navigationController?.pushViewController(detailController, animated: true)
    }
}

 

