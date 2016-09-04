//
//  PokeAPIConstants.swift
//  Pokedex
//
//  Created by IT on 8/29/16.
//  Copyright © 2016 z0s. All rights reserved.
//
import UIKit

extension PokeAPI {
    
    struct Poke {
        static let APIScheme = "http"
        static let APIHost = "pokeapi.co"
        static let APIPath = "/api/v2/"
    }
    
    // http://pokeapi.co/api/v2/
    
    // MARK: Pokemon API Response Keys
    struct PokeResponseKeys {
        static let ID = "id"
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
        static let Pages = "pages"
    }
    
    // MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
}
