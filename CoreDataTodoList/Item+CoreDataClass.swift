//
//  Item+CoreDataClass.swift
//  CoreDataTodoList
//
//  Created by Gareth on 06/10/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    static let identifier = "Item"
    
    @nonobjc static let fetchRequest: NSFetchRequest<Item> = { () -> NSFetchRequest<Item> in
        let request:NSFetchRequest<Item> = NSFetchRequest(entityName: Item.identifier)
        let sortDescriptor = NSSortDescriptor(key: "text", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }()
}
