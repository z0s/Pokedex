//
//  Pokemon+CoreDataProperties.swift
//  Pokedex
//
//  Created by IT on 9/1/16.
//  Copyright © 2016 z0s. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Pokemon {

    @NSManaged var name: String?
    @NSManaged var imageData: NSData?
    @NSManaged var type: String?
    @NSManaged var descriptionString: String?
    @NSManaged var id: Int
    @NSManaged var evolvesTo: Pokemon?
    @NSManaged var evolvesFrom: Pokemon?

}
