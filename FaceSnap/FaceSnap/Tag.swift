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
    
    static var allTagsRequest: NSFetchRequest<Tag> = {
        let request = NSFetchRequest<Tag>(entityName: Tag.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return request
    }()
    
    class func tag(withTitle title: String) -> Tag {
        let tag = NSEntityDescription.insertNewObject(forEntityName: Tag.entityName, into: CoreDataController.sharedInstance.managedObjectContext) as! Tag
        
        tag.title = title
        
        return tag
    }
    
}

extension Tag {
    @NSManaged var title: String
}
