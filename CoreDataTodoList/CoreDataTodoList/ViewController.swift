//
//  ViewController.swift
//  CoreDataTodoList
//
//  Created by Gareth on 04/10/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var TextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Save(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func Cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}

