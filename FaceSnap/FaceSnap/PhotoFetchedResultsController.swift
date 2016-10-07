//
//  PhotoFetchedResultsController.swift
//  FaceSnap
//
//  Created by Gareth on 04/10/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import UIKit
import CoreData

class PhotoFetchedResultsController: NSFetchedResultsController<Photo>, NSFetchedResultsControllerDelegate {
    
    private let collectionView: UICollectionView
    
    init(fetchRequest: NSFetchRequest<Photo>, managedObjectContext: NSManagedObjectContext, collectionView: UICollectionView) {
        
        self.collectionView = collectionView
        
        super.init(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        self.delegate = self
        
        executeFetch()
        
    }
    
    func executeFetch() {
        do {
            try performFetch()
        } catch let error {
            // handle error
            print(error)
        }
    }
    
    // optional as all will select all data no predicate
    func performFetchWithPredicate(withPredicate predicate: NSPredicate?) {
        // first delete all the caches (even though we are not caching), nil removes all
        NSFetchedResultsController<Photo>.deleteCache(withName: nil)
        
        fetchRequest.predicate = predicate
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // when changed
        collectionView.reloadData()
    }
}













