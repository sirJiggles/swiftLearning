//
//  Location.swift
//  FaceSnap
//
//  Created by Gareth on 04/10/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import CoreData

class Location: NSManagedObject {
    
    static let entityName = "\(Location.self)"
    
    class func locationWith(latitude: Double, longitude: Double) -> Location {
        let location = NSEntityDescription.insertNewObject(forEntityName: entityName, into: CoreDataController.sharedInstance.managedObjectContext) as! Location
        
        location.latitude = latitude
        location.longitude = longitude
        
        return location
    }
    
}

extension Location {
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
}
