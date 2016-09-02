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
    
    // MARK: Flickr Parameter Keys
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let Latitude = "lat"
        static let Longitude = "lon"
        static let Radius = "radius"
        static let GalleryID = "gallery_id"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let PerPage = "per_page"
        static let Page = "page"
    }
    
    
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
