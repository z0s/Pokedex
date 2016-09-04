//
//  PokeAPI.swift
//  pokedex
//
//  Created by IT on 8/29/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import UIKit
import CoreData

typealias CompletionBlock = (success: Bool) -> Void

struct PokeAPI {
    
    static let session = NSURLSession.sharedSession()
    static let baseURL = pokemonURLFromParameters(nil)
    
    static func requestAllPokemon(startID: Int, completion: CompletionBlock?) {
        for i in startID...151 {
            PokeAPI.requestPokemonForID(i, completion: { (success) in
                if success {
                    if let completion = completion {
                        completion(success: true)
                    }
                }
            })
        }
    }
    
    static func requestPokemonForID(id: Int, completion: CompletionBlock?) {
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
                            if let imageURLString = spritesDict["front_default"] as? String {
                                pokemon.urlString = imageURLString
                            }
                        }
                        
                        if let typeDictArray = jsonDict["types"] as? [[String:AnyObject]] {
                            for typeDict in typeDictArray {
                                if let typeDictionary = typeDict["type"] as? [String:String] {
                                    if let typeName = typeDictionary["name"] {
                                        if !pokemon.types.contains(typeName) {
                                            pokemon.types.append(typeName)
                                        }
                                    }
                                }
                            }
                        }
                        
                        PokemonDataProvider.save()
                        
                        session.getAllTasksWithCompletionHandler({ tasks in
                            if tasks.count == 0 {
                                if let completion = completion {
                                    completion(success: true)
                                }
                            } else {
                                if let completion = completion {
                                    completion(success: false)
                                }
                            }
                        })
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
                    dispatch_async(dispatch_get_main_queue(), {
                        guard let pokemon = PokemonDataProvider.fetchPokemonForID(id) else {
                            return
                        }
                        
                        if let descDictArray = json["descriptions"] as? [[String:AnyObject]] {
                            for descDict in descDictArray {
                                if let languageDict = descDict["language"] as? [String:String] {
                                    if let language = languageDict["name"] where language == "en" {
                                        if let description = descDict["description"] as? String {
                                            pokemon.descriptionString = description
                                            PokemonDataProvider.save()
                                            
                                            let note = NSNotification(name: "PokemonDescriptionDidFinishDownloading", object: nil)
                                            
                                            NSNotificationCenter.defaultCenter().postNotification(note)
                                        }
                                    }
                                }
                            }
                        }
                        
                    })
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