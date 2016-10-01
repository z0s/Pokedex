//
//  CollectionViewController.swift
//  pokedex
//
//  Created by IT on 8/22/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class CollectionViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var pokemonArray = [Pokemon]()
    
    let errorMessage = "Looks like there is no connection to the internet!"
    let errorTitle = "No Internet Connection"
    let errorActionTitle = "OK"
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Pokedex"
        gradientLayer()
    
        // Register cell classes
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView!.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        pokemonArray = PokemonDataProvider.fetchPokemon()
        NotificationCenter.default.addObserver(self, selector: #selector(downloadError), name: NSNotification.Name(rawValue: "PokemonDownloadError"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataUpdated), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(downloadFinished), name: NSNotification.Name(rawValue: "PokemonDidFinishDownloading"), object: nil)

        refreshControl.tintColor = UIColor.gray
        refreshControl.addTarget(self, action: #selector(fetchMorePokemon), for: .valueChanged)
        
        self.collectionView.addSubview(refreshControl)
        self.collectionView.alwaysBounceVertical = true
        
    }
    
    func downloadFinished() {
        refreshControl.endRefreshing()
    }
    
    func fetchMorePokemon() {
        PokeAPI.fetchNext15Pokemon()
    }
    
    fileprivate func gradientLayer() {
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [red.aRed.cgColor as CGColor, red.bRed.cgColor as CGColor]
        gradient.locations = [0.0, 1.0]
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    func downloadError() {
        presentAlert(errorTitle, message: errorMessage, actionTitle: errorActionTitle)
    }
    
    func dataUpdated() {
        pokemonArray = PokemonDataProvider.fetchPokemon()
        collectionView.reloadData()
    }
}

    // MARK: UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        let pokemon = pokemonArray[(indexPath as NSIndexPath).row]
        cell.pokemon = pokemon
        // Configure the cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return pokemonArray.count
    }
    
    
}

// MARK: UICollectionViewDelegate
extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let detailController: ImageDetailViewController = storyboard.instantiateViewController(withIdentifier: "ImageDetail") as! ImageDetailViewController
        
        let pokemon = pokemonArray[(indexPath as NSIndexPath).row]
        detailController.pokemon = pokemon
        self.navigationController?.pushViewController(detailController, animated: true)
    }
}

extension CollectionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y == (scrollView.contentSize.height - scrollView.frame.size.height)) {
            //reach bottom
            PokeAPI.fetchNext15Pokemon()
        }
    }
}

 

