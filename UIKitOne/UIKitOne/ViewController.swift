//
//  ViewController.swift
//  UIKitOne
//
//  Created by Gareth Fuller on 31/07/16.
//  Copyright © 2016 Gareth Fuller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet var label: UILabel?
  var count = 0;
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
//    THIS IS HOW YOU DO IT PROGRAMATICALY
//    let label = UILabel()
//    label.frame = CGRectMake(150, 150, 60, 60)
//    label.text = "0"
//    
//    self.view.addSubview(label)
//    self.label = label
//    
//    // button
//    let button = UIButton()
//    button.frame = CGRectMake(150, 250, 140, 60)
//    button.setTitle("Click me", forState: .Normal)
//    button.setTitleColor(UIColor.blueColor(), forState: .Normal)
//    self.view.addSubview(button)
//    
//    button.addTarget(self, action: #selector(ViewController.incrementCount), forControlEvents: .TouchUpInside)
    
  }
  
  @IBAction func incrementCount() {
    self.count += 1
    self.label?.text = "\(self.count)"
  }

}

