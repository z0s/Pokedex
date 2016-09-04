//
//  PokeAPI.swift
//  pokedex
//
//  Created by IT on 8/29/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import UIKit
import CoreData

struct PokeAPI {
    
    static let session = NSURLSession.sharedSession()
    static let baseURL = pokemonURLFromParameters(nil)
    
    static func requestPokemonForID(id: Int) {
        //let fetchRequest = NSFetchRequest(entityName: Pokemon.entityName())
        //fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        let stack = (UIApplication.sharedApplication().delegate as? AppDelegate)?.stack
        
//        if let count = stack?.context.countForFetchRequest(fetchRequest, error: nil) where count > 0 {
//            return
//        }
        
        let url = NSURL(string: "pokemon/\(id)", relativeToURL: baseURL)
        let request = NSURLRequest(URL: url!)
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard let urlResponse = response as? NSHTTPURLResponse where (urlResponse.statusCode > 200 || urlResponse.statusCode < 300) else {
                return
            }
            
            if let data = data {
                if let jsonDict = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) {
                    dispatch_async(dispatch_get_main_queue(), {
                        guard let name = jsonDict["name"] as? String else {
                            return
                        }
                        
                        var pokemon: Pokemon
                        if let pokemonInCoreData = PokemonDataProvider.fetchPokemonForID(id) {
                            pokemon = pokemonInCoreData
                        } else {
                            pokemon = Pokemon(id: id, name: name.capitalizedString)
                        }
                        
                        if let spritesDict = jsonDict["sprites"] as? [String:AnyObject] {
                            let imageURLString = spritesDict["front_default"] as? String
                            pokemon.urlString = imageURLString
                        }
                        
                        stack?.saveContext()
                    })
                    
                    print(jsonDict)
                }
            }
        }
        
        task.resume()
    }
    
    
    static func requestPokemonDescriptionForID(id: Int) {
        let url = NSURL(string: "characteristic/\(id)", relativeToURL: baseURL)
        let task = session.dataTaskWithURL(url!) { (data, response, error) in
            guard let urlResponse = response as? NSHTTPURLResponse where (urlResponse.statusCode > 200 || urlResponse.statusCode < 300) else {
                return
            }
            if let data = data {
                if let json = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments){
                    print(json)
                }
            }
        }
        task.resume()
        
    }
    
}
// MARK: Helper for Creating a URL from Parameters

func pokemonURLFromParameters(parameters: [String:AnyObject]?) -> NSURL {
    let components = NSURLComponents()
    
    components.scheme = PokeAPI.Poke.APIScheme
    components.host = PokeAPI.Poke.APIHost
    components.path = PokeAPI.Poke.APIPath
    var queryItems = [NSURLQueryItem]()
    
    if let parameters = parameters {
        for (key, value) in parameters {
            let  queryItem = NSURLQueryItem(name: key, value: "\(value)")
            queryItems.append(queryItem)
        }
        components.queryItems = queryItems
    }
    return components.URL!
    
}