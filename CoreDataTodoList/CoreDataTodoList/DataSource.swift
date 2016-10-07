//
//  DataSource.swift
//  CoreDataTodoList
//
//  Created by Gareth on 07/10/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// all datasource responsibility for the table view controller (Single Responsibility)
// this is object c class (hense the inheritance)
class DataSource: NSObject, UITableViewDataSource {
    private let tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    let managedObjectContext = DataController.sharedInstance.managedObjectContext
    
    lazy var fetchResultsController: TodoFetchedResultsController = {
        // as this initilizer uses lazy vars we need to use self to indicate the fact that they may not ezist until called
        let controller = TodoFetchedResultsController(managedObjectContext: self.managedObjectContext, withTableView: self.tableView)
        
        return controller
    }()
    
    func object(at indexPath: IndexPath) -> Item {
        return fetchResultsController.object(at: indexPath)
    }
    
    // MARK: - UITableViewDelegate
    
    // enable swipe to delete
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    // confirm the delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let item = fetchResultsController.object(at: indexPath) as NSManagedObject
        
        managedObjectContext.delete(item)
        
        DataController.sharedInstance.saveContext()
    }

    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchResultsController.sections?[section] else {
            return 0
        }
        return section.numberOfObjects
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return configureCell(cell: cell, atIndexPath: indexPath)
    }
    
    private func configureCell(cell: UITableViewCell, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let item = fetchResultsController.object(at: indexPath)
        cell.textLabel?.text = item.text
        return cell
    }

}
