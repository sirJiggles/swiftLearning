//
//  Tag.swift
//  FaceSnap
//
//  Created by Gareth on 04/10/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import CoreData

class Tag: NSManagedObject {
    
    // Tag self returns the name of the class
    static let entityName = "\(Tag.self)"
    
    class func tag(withTitle title: String) -> Tag {
        let tag = NSEntityDescription.insertNewObject(forEntityName: Tag.entityName, into: CoreDataController.sharedInstance.managedObjectContext) as! Tag
        
        tag.title = title
        
        return tag
    }
    
}

extension Tag {
    @NSManaged var title: String
}
