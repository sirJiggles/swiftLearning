//
//  SortableDataSource.swift
//  FaceSnap
//
//  Created by Gareth on 07/10/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// making sure the items have titles makes sure we have something nice to show
// the user
protocol CustomTitleConvertable {
    var title: String { get }
}

extension Tag: CustomTitleConvertable {}

class SortableDataSource<SortType: CustomTitleConvertable>: NSObject, UITableViewDataSource where SortType: NSManagedObject {
    
    private let fetchedResultsController: NSFetchedResultsController<SortType>
    
    var results: [SortType] {
        return fetchedResultsController.fetchedObjects!
    }
    
    init(fetchRequest: NSFetchRequest<SortType>, managedObjectContext moc: NSManagedObjectContext) {
        self.fetchedResultsController = NSFetchedResultsController<SortType>(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        // NSObject requires
        super.init()
        
        executeFetch()
    }
    
    func executeFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        // 2 because there will be two sections, 1st with all tags, second will list all tags for selection
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return fetchedResultsController.fetchedObjects?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "SortableItemCell")
        cell.selectionStyle = .none
        
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            cell.textLabel?.text = "All \(SortType.self)s"
            cell.accessoryType = .checkmark
        // second section and all rows (hense the underscore
        case (1,_):
            guard let sortItem = fetchedResultsController.fetchedObjects?[indexPath.row] else {
                break
            }
            cell.textLabel?.text = sortItem.title
        default:
            break
        }
        
        return cell
    }
    
}






