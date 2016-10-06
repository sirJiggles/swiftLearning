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
    
    // our items to be displayed
    var items:[Item] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var fetchRequest: NSFetchRequest = { () -> NSFetchRequest<Item> in
        let request:NSFetchRequest<Item> = NSFetchRequest(entityName: Item.identifier)
        let sortDescriptor = NSSortDescriptor(key: "text", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            items = try managedObjectContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("error fetching item objects \(error.localizedDescription), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = items[indexPath.row].text

        return cell
    }
 

}
