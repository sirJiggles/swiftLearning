//
//  CurrentWeather.swift
//  Stormy
//
//  Created by Gareth on 21/08/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeather {
  let temperature: Double
  let humidity: Double
  let chaceOfRain: Double
  let summary: String
  let icon: UIImage
}


extension CurrentWeather: JSONDecodable {
  init?(json: [String : AnyObject]) {
    guard let temperature = json["temperature"] as? Double,
      humidity = json["humidity"] as? Double,
      chaceOfRain = json["precipProbability"] as? Double,
      summary = json["summary"] as? String,
      iconString = json["icon"] as? String else {
        return nil
    }
    
    let icon = WeatherIcon(rawValue: iconString).image
    self.temperature = temperature
    self.humidity = humidity
    self.chaceOfRain = chaceOfRain
    self.summary = summary
    self.icon = icon
  }
}
