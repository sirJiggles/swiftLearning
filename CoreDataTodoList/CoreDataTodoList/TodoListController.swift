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
    
    lazy var dataSource: DataSource = {
        return DataSource(tableView: self.tableView)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            let item = dataSource.object(at: indexPath)
            destinationController.item = item
        }
    }

}
