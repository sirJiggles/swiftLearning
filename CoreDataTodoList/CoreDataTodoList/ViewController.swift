//
//  ViewController.swift
//  CoreDataTodoList
//
//  Created by Gareth on 04/10/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var TextField: UITextField!
    
    let dataController = DataController.sharedInstance
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Save(_ sender: AnyObject) {
        guard let text = TextField.text else {
            return
        }
        
        // register managed object with a context
        let item = NSEntityDescription.insertNewObject(forEntityName: Item.identifier, into: dataController.managedObjectContext) as! Item
        
        item.text = text
        
        dataController.saveContext()
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func Cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}

