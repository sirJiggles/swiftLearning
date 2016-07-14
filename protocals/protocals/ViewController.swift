//
//  ViewController.swift
//  protocals
//
//  Created by Gareth Fuller on 30/06/16.
//  Copyright © 2016 Gareth Fuller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    let domesticFlight = Flight(type: DomesticAirlineType.American)
    print(domesticFlight.requestLandingInstrutions())
    
    let internationalFlight = Flight(type: InternationAirlineType.AirFrance)
    print(internationalFlight.requestLandingInstrutions())
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

