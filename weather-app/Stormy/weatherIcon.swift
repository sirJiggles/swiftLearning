//
//  weatherIcon.swift
//  Stormy
//
//  Created by Gareth Fuller on 26/06/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation
import UIKit

enum weatherIcon: String {
  case ClearDay = "clear-day"
  case ClearNight = "clear-night"
  case Rain = "rain"
  case Snow = "snow"
  case Sleet = "sleet"
  case Wind = "wind"
  case Fog = "fog"
  case Cloudy = "cloudy"
  case PartlyCloudyDay = "partly-cloudy-day"
  case PartlyCloudyNight = "partly-cloudy-night"
  case UnexpectedType = "default"
}

extension weatherIcon {
  var image: UIImage{
    return UIImage(named: self.rawValue)!
  }
  
}
