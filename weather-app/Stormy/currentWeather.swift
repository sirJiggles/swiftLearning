//
//  currentWeather.swift
//  Stormy
//
//  Created by Gareth Fuller on 26/06/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import Foundation

struct currentWeather {
  let temperature: Double
  let humidity: Double
  //  Will it rain
  let precipitationProbability: Double
  let summary: String
  //  Comes from the API as an image but we will display an image
  let icon: UIImage
}
