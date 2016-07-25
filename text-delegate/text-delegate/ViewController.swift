//
//  ViewController.swift
//  text-delegate
//
//  Created by Gareth Fuller on 23/07/16.
//  Copyright © 2016 Gareth Fuller. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

  @IBOutlet weak var submitButton: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    let length = (textField.text?.characters.count)! - range.length + string.characters.count
    print("the length is: \(length) ")
    if length > 0 {
      submitButton.enabled = true
    } else {
      submitButton.enabled = false
    }
    return true
  }


}

