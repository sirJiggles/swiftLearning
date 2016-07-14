//
//  ViewController.swift
//  playground
//
//  Created by Gareth Fuller on 25/06/16.
//  Copyright © 2016 Gareth Fuller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  let blueView = UIView()
  let greenView = UIView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(blueView)
    view.addSubview(greenView)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    blueView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    greenView.backgroundColor = UIColor(red: 255.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
    blueView.translatesAutoresizingMaskIntoConstraints = false
    greenView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activateConstraints([
      NSLayoutConstraint(item: blueView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100.0),
      NSLayoutConstraint(item: blueView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .LeftMargin, multiplier: 1.0, constant: 8.0),
      NSLayoutConstraint(item: blueView, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: 8.0),
      NSLayoutConstraint(item: blueView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .RightMargin, multiplier: 1.0, constant: -8.0)
      ])
 
    NSLayoutConstraint.activateConstraints([
      NSLayoutConstraint(item: greenView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 75.0),
      NSLayoutConstraint(item: greenView, attribute: .Top, relatedBy: .Equal, toItem: blueView, attribute: .Bottom, multiplier: 1.0, constant: 8.0),
      NSLayoutConstraint(item: greenView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .LeftMargin, multiplier: 1.0, constant: 8.0),
      NSLayoutConstraint(item: greenView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .RightMargin, multiplier: 1.0, constant: -8.0)
    ])
    
  }


}

