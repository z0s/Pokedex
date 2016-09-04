//
//  PokemonDataProvider.swift
//  Pokedex
//
//  Created by IT on 9/2/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import UIKit
import CoreData

class PokemonDataProvider: NSObject {
    static let stack = (UIApplication.sharedApplication().delegate as! AppDelegate).stack
    
    class func fetchPokemon() -> [Pokemon] {
        let fetchRequest = NSFetchRequest(entityName: Pokemon.entityName())
        let idSortDescriptor = NSSortDescriptor(key: PokeAPI.PokeResponseKeys.ID, ascending: true)
        fetchRequest.sortDescriptors = [idSortDescriptor]
        
        do {
            if let pokemonArray = try stack.context.executeFetchRequest(fetchRequest) as? [Pokemon] {
                return pokemonArray
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    class func fetchPokemonForID(id: Int) -> Pokemon? {
        let fetchRequest = NSFetchRequest(entityName: Pokemon.entityName())
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            if let pokemonArray = try stack.context.executeFetchRequest(fetchRequest) as? [Pokemon] {
                return pokemonArray.first
            }
        } catch {
            
        }
        
        return nil
    }
}
