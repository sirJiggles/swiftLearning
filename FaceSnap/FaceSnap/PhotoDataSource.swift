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

class PhotoDataSource: NSObject {
    fileprivate let collectionView: UICollectionView
    fileprivate let managedObjectContext = CoreDataController.sharedInstance.managedObjectContext
    
    fileprivate let fetchedResultsController: PhotoFetchedResultsController
    
    init(fetchRequest: NSFetchRequest<Photo>, collectionView: UICollectionView) {
        
        self.collectionView = collectionView
        self.fetchedResultsController = PhotoFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, collectionView: self.collectionView)
        
        super.init()
    }

}

// MARK: - UICollectionViewDataSource
extension PhotoDataSource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get cell get photo and assign to image view
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
        
        // get the image
        let photo = fetchedResultsController.object(at: indexPath)
        
        cell.imageView.image = photo.photoimage
        
        return cell
    }
    
}
