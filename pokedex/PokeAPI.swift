//
//  PokeAPI.swift
//  pokedex
//
//  Created by IT on 8/29/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import UIKit
import CoreData

typealias CompletionBlock = (_ allDownloadsCompleted: Bool, _ error: NSError?) -> Void

struct PokeAPI {
    
    static let session = URLSession.shared
    static let baseURL = pokemonURLFromParameters(nil)
    
    static func fetchNext15Pokemon() {
        session.getAllTasks(completionHandler: { tasks in
            if tasks.count > 0 {
                return
            }
        })
        
        // all existing Pokemon in DB
        let pokemonArray = PokemonDataProvider.fetchPokemon()
        
        var startID: UInt
        if let lastIdDownloaded = pokemonArray.last?.id {
            startID = lastIdDownloaded.uintValue
        } else {
            startID = 0
        }
        
        let note = Notification(name: Notification.Name(rawValue: "PokemonDidFinishDownloading"), object: nil)
        
        if startID < 151 {
            let window = (UIApplication.shared.delegate as? AppDelegate)?.window
            if let rootVC = window?.rootViewController {
                for view in rootVC.view.subviews {
                    if view is UIActivityIndicatorView {
                        view.removeFromSuperview()
                    }
                }
            }
            let spinner = window?.rootViewController?.showSpinner()
            PokeAPI.requestPokemon(startID, num: 15, completion: { (allDownloadsCompleted, error) in
                NotificationCenter.default.post(note)
                if let rootVC = window?.rootViewController {
                    for view in rootVC.view.subviews {
                        if view is UIActivityIndicatorView {
                            view.removeFromSuperview()
                        }
                    }
                }
                spinner?.hide()
            })
        } else {
            NotificationCenter.default.post(note)
        }
    }
    
    static func requestPokemon(_ startID: UInt, num: UInt, completion: CompletionBlock?) {
        var endID = startID + num
        endID = min(151, endID)
        for i in startID...endID {
            PokeAPI.requestPokemonForID(i, completion: { (allDownloadsCompleted, error) in
                if let completion = completion {
                    completion(allDownloadsCompleted, error)
                }
            })
        }
    }
    
    static func requestPokemonForID(_ id: UInt, completion: CompletionBlock?) {
        if let _ = PokemonDataProvider.fetchPokemonForID(id) {
            return
        }
        
        session.getAllTasks { tasks in
            for task in tasks {
                if task.taskDescription == "\(id)" {
                    return
                }
            }
        }
        
        let url = URL(string: "pokemon/\(id)", relativeTo: baseURL)
        let request = URLRequest(url: url!)
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error as? NSError {
                print(error.localizedDescription)
                if error.code == NSURLErrorNotConnectedToInternet {
                    let note = Notification(name: Notification.Name(rawValue: "PokemonDownloadError"), object: nil)
                    NotificationCenter.default.post(note)
                }
                
                if let completion = completion {
                    completion(false, error as NSError?)
                }
                return
            }
            
            guard let urlResponse = response as? HTTPURLResponse , (urlResponse.statusCode > 200 || urlResponse.statusCode < 300) else {
                return
            }
            
            if let data = data {
                if let jsonDict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject] {
                    DispatchQueue.main.async(execute: {
                        guard let name = jsonDict["name"] as? String else {
                            return
                        }
                    
                        var pokemon: Pokemon
                        if let pokemonInDB = PokemonDataProvider.fetchPokemonForID(id) {
                            pokemon = pokemonInDB
                        } else {
                            pokemon = Pokemon(id: id, name: name.capitalized)
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
                        
                        session.getAllTasks(completionHandler: { tasks in
                            if tasks.count == 0 {
                                if let completion = completion {
                                    completion(true, nil)
                                }
                            }
                        })
                    })
                }
            }
        }) 
        
        task.taskDescription = "\(id)"
        
        task.resume()
    }
    
    
    static func requestPokemonDescriptionForID(_ id: UInt) {
    
        let url = URL(string: "characteristic/\(id)", relativeTo: baseURL)
        let task = session.dataTask(with: url!, completionHandler: { (data, response, error) in
            guard let urlResponse = response as? HTTPURLResponse , (urlResponse.statusCode > 200 || urlResponse.statusCode < 300) else {
                return
            }
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    DispatchQueue.main.async(execute: {
                        guard let pokemon = PokemonDataProvider.fetchPokemonForID(id) else {
                            return
                        }
                        
                        if let descDictArray = json?["descriptions"] as? [[String:AnyObject]] {
                            for descDict in descDictArray {
                                if let languageDict = descDict["language"] as? [String:String] {
                                    if let language = languageDict["name"] , language == "en" {
                                        if let description = descDict["description"] as? String {
                                            pokemon.descriptionString = description
                                            PokemonDataProvider.save()
                                            
                                            let note = Notification(name: Notification.Name(rawValue: "PokemonDescriptionDidFinishDownloading"))
                                            
                                            NotificationCenter.default.post(note)
                                        }
                                    }
                                }
                            }
                        }
                        
                    })
                }
            }
        }) 
        task.resume()
        
    }
    
    static func requestImageForPokemon(_ pokemon: Pokemon, completion: ((_ image: UIImage?, _ error: NSError?) -> Void)?) {
        let url = URL(string: pokemon.urlString)!
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let urlResponse = response as? HTTPURLResponse , (urlResponse.statusCode > 200 || urlResponse.statusCode < 300) else {
                if let completion = completion {
                    completion(nil, nil)
                }
                return
            }
            if let error = error {
                if let completion = completion {
                    completion(nil, error as NSError?)
                }
                return
            }
            
            if let data = data {
                DispatchQueue.main.async(execute: {
                    pokemon.imageData = data
                    PokemonDataProvider.save()
                    let image = UIImage(data: data)
                    if let completion = completion {
                        completion(image, nil)
                    }
                })
            }
        }) 
        
        task.resume()
    }
    
}
// MARK: Helper for Creating a URL from Parameters

func pokemonURLFromParameters(_ parameters: [String:AnyObject]?) -> URL {
    var components = URLComponents()
    
    components.scheme = PokeAPI.Poke.APIScheme
    components.host = PokeAPI.Poke.APIHost
    components.path = PokeAPI.Poke.APIPath
    var queryItems = [URLQueryItem]()
    
    if let parameters = parameters {
        for (key, value) in parameters {
            let  queryItem = URLQueryItem(name: key, value: "\(value)")
            queryItems.append(queryItem)
        }
        components.queryItems = queryItems
    }
    return components.url!
    
}
