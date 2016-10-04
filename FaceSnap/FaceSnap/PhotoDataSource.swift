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
    
    init(fetchRequest: NSFetchRequest, collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
}
