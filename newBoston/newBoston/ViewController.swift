//
//  ViewController.swift
//  newBoston
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

  @IBOutlet weak var emailAddress: UITextField!
  @IBOutlet weak var password: UITextField!
  
  //  Clicking on login
  @IBAction func pressLogin(_ sender: UIButton) {
    // give up first responder priority
    self.emailAddress.resignFirstResponder()
    self.password.resignFirstResponder()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    // end editing of all items 
    self.view.endEditing(true)
    
  }
  
}

