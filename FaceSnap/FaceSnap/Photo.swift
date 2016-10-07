//
//  Photo.swift
//  FaceSnap
//
//  Created by Gareth on 04/10/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class Photo: NSManagedObject {
    static let entityName = "\(Photo.self)"
    
    class func photo(withImage image: UIImage) -> Photo {
        let photo = NSEntityDescription.insertNewObject(forEntityName: entityName, into: CoreDataController.sharedInstance.managedObjectContext) as! Photo
        
        photo.date = NSDate().timeIntervalSince1970
        
        // convert the image to the data format needed to store using a global function
        // compression quality is passed, 0 max compression 1.0 is max and 0 is lowest qualty
        // we will just use max for now
        photo.image = UIImageJPEGRepresentation(image, 1.0)! as NSData
        
        return photo
    }
    
    class func photoWith(image: UIImage, tags: [String], location: CLLocation?) {
        let photo = Photo.photo(withImage: image)
        
        photo.addTags(tags: tags)
        
        photo.addLocation(location: location)
        
    }
    
    // adding the location
    func addLocation(location: CLLocation?) {
        if let location = location {
            let photoLocation = Location.locationWith(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.location = photoLocation
        }
    }
    
    
    // Adding tags
    func addTag(withTitle title: String) {
        let tag = Tag.tag(withTitle: title)
        tags.insert(tag)
    }
    
    func addTags(tags: [String]) {
        for tag in tags {
            addTag(withTitle: tag)
        }
    }
}

extension Photo {
    @NSManaged var date: TimeInterval
    @NSManaged var image: NSData
    
    // we dont want duplicates, so set is awesome here. Also can init as empty
    @NSManaged var tags: Set<Tag>
    
    @NSManaged var location: Location?
    
    // return UI image from the image property
    var photoimage: UIImage {
        return UIImage(data: image as Data)!
    }
}

// photo request fetch
extension Photo {
    @nonobjc static var allPhotosRequest: NSFetchRequest<Photo> = { () -> NSFetchRequest<Photo> in
        let request = NSFetchRequest<Photo>(entityName: Photo.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return request
    }()
}


