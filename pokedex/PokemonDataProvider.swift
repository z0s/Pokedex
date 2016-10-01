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
    static fileprivate let stack = (UIApplication.shared.delegate as! AppDelegate).stack
    
    class func fetchPokemon() -> [Pokemon] {
        let fetchRequest = NSFetchRequest<Pokemon>(entityName: Pokemon.entityName())
        let idSortDescriptor = NSSortDescriptor(key: PokeAPI.PokeResponseKeys.ID, ascending: true)
        fetchRequest.sortDescriptors = [idSortDescriptor]
        
        do {
            let pokemonArray = try stack.context.fetch(fetchRequest)
            return pokemonArray
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    class func fetchPokemonForID(_ id: UInt) -> Pokemon? {
        let fetchRequest = NSFetchRequest<Pokemon>(entityName: Pokemon.entityName())
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let pokemonArray = try stack.context.fetch(fetchRequest)
            return pokemonArray.first
        } catch {
            
        }
        
        return nil
    }
    
    class func save() {
        stack.saveContext()
    }
}
