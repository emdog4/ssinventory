//
//  Item.swift
//  SSInventory
//
//  Created by Emery Clark on 5/2/15.
//  Copyright (c) 2015 Silicon Solutions. All rights reserved.
//

import Foundation
import CoreData

class Item: NSManagedObject {

    @NSManaged var category: String
    @NSManaged var make: String
    @NSManaged var model: String
    @NSManaged var note: String
    @NSManaged var price: NSNumber

}
