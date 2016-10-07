//
//  DetailViewController.swift
//  CoreDataTodoList
//
//  Created by Gareth on 06/10/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var textFiled: UITextField!
    
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let item = item else {
            fatalError("Cannot show detail without an item")
        }
        
        textFiled.text = item.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func save(_ sender: AnyObject) {
        if let item = item {
            item.text = textFiled.text
            DataController.sharedInstance.saveContext()
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    

}
