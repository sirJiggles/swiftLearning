//
//  PhotoDataSource.swift
//  FaceSnap
//
//  Created by Gareth on 04/10/16.
//  Copyright © 2016 Gareth. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class PhotoDataSource {
    fileprivate let collectionView: UICollectionView
    fileprivate let managedObjectContext = CoreDataController.sharedInstance.managedObjectContext
    
    private let fetchedResultsController: PhotoFetchedResultsController
    
    init(fetchRequest: NSFetchRequest<Photo>, collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.fetchedResultsController = PhotoFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, collectionView: self.collectionView)
    }
}
