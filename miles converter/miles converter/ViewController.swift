//
//  ViewController.swift
//  miles converter
//
//  Created by Gareth Fuller on 19/06/16.
//  Copyright © 2016 Gareth Fuller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //  Connect the UI elements
  @IBOutlet weak var milesField: UITextField!
  @IBOutlet weak var resultsLabel: UILabel!
  
  @IBAction func convertBtn(_ sender: UIButton) {
    // 1 mile is 5280.0 feet
    // get value user inputs
    // convert text to float
    // convert back to text and set label
    
    resultsLabel.text = String(Float(milesField.text!)! * 5280.0)
    
  }
}

