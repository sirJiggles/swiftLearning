//
//  TodoListController.swift
//  CoreDataTodoList
//
//  Created by Gareth on 06/10/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import UIKit
import CoreData

class TodoListController: UITableViewController {
    
    let managedObjectContext = DataController.sharedInstance.managedObjectContext

    
    lazy var fetchResultsController: TodoFetchedResultsController = {
        // as this initilizer uses lazy vars we need to use self to indicate the fact that they may not ezist until called
        let controller = TodoFetchedResultsController(managedObjectContext: self.managedObjectContext, withTableView: self.tableView)
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchResultsController.sections?[section] else {
            return 0
        }
        return section.numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        return configureCell(cell: cell, atIndexPath: indexPath)
    }
    
    private func configureCell(cell: UITableViewCell, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let item = fetchResultsController.object(at: indexPath)
        cell.textLabel?.text = item.text
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    // enable swipe to delete
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    // confirm the delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let item = fetchResultsController.object(at: indexPath) as NSManagedObject
        
        managedObjectContext.delete(item)
        
        DataController.sharedInstance.saveContext()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItem" {
            guard
                let destinationController = segue.destination as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else {
                // todo let the user knw why not working
                    return
            }
            
            let item = fetchResultsController.object(at: indexPath)
            destinationController.item = item
        }
    }

}
