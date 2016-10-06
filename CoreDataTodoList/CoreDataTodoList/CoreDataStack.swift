//
//  CoreDataStack.swift
//  CoreDataTodoList
//
//  Created by Gareth on 04/10/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import Foundation
import CoreData

public class DataController: NSObject {
    // each app has container in its sandbox for exaple bundler
    // there is also data container, data used by app and user. This is 
    // then divided into more directorys and the one we care about here is
    // the documents directory. This is where you usually store user
    // generated content. This is also backed up to iCloud or i tunes :D
    
    // get the lcation, any type of url including location on disk
    private lazy var applicationDocumentsDirectory: NSURL = {
       
        // using nsfile manager get urls of documents dir (user domain 
        // mask is users home directory in this app)
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // user items first then system items last is the order of the URLS
        // here and the one we are interested in is the last system one
        return urls[urls.count - 1] as NSURL
    }()
    
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // init the managed object model from file
        let modelUrl = Bundle.main.url(forResource: "Todolist", withExtension: "momd")!
        
        // create an return managed object model
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl)
        return managedObjectModel!
        
    }()
    
    
    // MARK: - Persistance
    
    // taks between the store and the managed objects
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // the bridge
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        // where will we save?
        
        // location is a URL, app
        let url = self.applicationDocumentsDirectory.appendingPathComponent("TodoList.sqlite")
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            let userInfo: [String: AnyObject] = [
                NSLocalizedDescriptionKey: "Failed to init the applications saved data" as AnyObject,
                NSLocalizedFailureReasonErrorKey: "There was an error creating or loading the apps saved data" as AnyObject,
                NSUnderlyingErrorKey: error as NSError
            ]
            let wrappedError = NSError(domain: "com.gareth.coredataError", code: 9999, userInfo: userInfo)
            print("unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
            
        }
        
        return coordinator
    }()
    
    // MARK: - Manage Object Context
    
    // when we save the objects, the state is checked to see if valid, if they are they are added to the persistence
    // from there the are added to the store. This helps keep track of changes and being able to undo and redo
    // for example. As we will be using this offen it is public as apposed to the private ones above
    public lazy var managedObjectContext: NSManagedObjectContext = {
        // assign the persistance store coordinator to local constant
        let coordinator = self.persistentStoreCoordinator
        
        // cerate instance of ns manage obj context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        return managedObjectContext
    }()
    
    
}



