//
//  ViewController.swift
//  sliderColorPicker
//
//  Created by Gareth Fuller on 31/07/16.
//  Copyright © 2016 Gareth Fuller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  

  @IBOutlet weak var bgColorView: UIView!
  
  @IBOutlet weak var redSlider: UISlider!
  @IBOutlet weak var greenSlider: UISlider!
  @IBOutlet weak var blueSlider: UISlider!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  @IBAction func changeColor() {
    let r = CGFloat(redSlider.value)
    let g = CGFloat(greenSlider.value)
    let b = CGFloat(blueSlider.value)
    
    bgColorView.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

