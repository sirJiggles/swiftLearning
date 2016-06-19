//
//  ViewController.swift
//  TipCalculator
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

  @IBOutlet weak var BillAmountField: UITextField!
  @IBOutlet weak var TipPercentageLabel: UILabel!
  @IBOutlet weak var TotalLabel: UILabel!
  @IBOutlet weak var TipAmountLabel: UILabel!
  @IBOutlet weak var TipSliderValue: UISlider!
  

  @IBAction func TipChanged(_ sender: UISlider) {
    TipPercentageLabel.text! = "Tip Percentage " + String(Int(sender.value)) + "%"
    calculateTip()
  }
  
  @IBAction func CalculatePressed(_ sender: UIButton) {
    calculateTip()
  }
  
  func calculateTip() {
    if let bill = Float(BillAmountField.text!) {
      let tipAmount = bill * TipSliderValue.value/100
      let total = tipAmount + bill
    
      TotalLabel.text! = "Total " + String(total)
      TipAmountLabel.text! = "Tip Amount " + String(tipAmount)
    }
  }
  
}

