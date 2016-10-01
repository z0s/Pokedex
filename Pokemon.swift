//
//  Pokemon.swift
//  Pokedex
//
//  Created by IT on 9/1/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import CoreData
import UIKit

class Pokemon: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    convenience init(id: UInt, name: String) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.stack.context, let ent = NSEntityDescription.entity(forEntityName: Pokemon.entityName(), in: context) {
            self.init(entity: ent, insertInto: context)
            self.id = NSNumber(value: id as UInt)
            self.name = name
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
    
    class func entityName() -> String {
        return "Pokemon"
    }
}
