//
//  ForcastClient.swift
//  Stormy
//
//  Created by Gareth on 28/08/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation

struct Coordinate {
  let latitude: Double
  let longitude: Double
}

enum Forecast: EndPoint {
  case Current(token: String, coordinate: Coordinate)
  
  
  var baseUrl: NSURL {
    return NSURL(string: "https://api.forecast.io")!
  }
  var path: String {
    switch self {
    case .Current(let token, let coordinate):
      return "/forecast/\(token)/\(coordinate.latitude),\(coordinate.longitude)"
    }
  }
  var request: NSURLRequest {
    let url = NSURL(string: path, relativeToURL: baseUrl)!
    return NSURLRequest(URL: url)
  }
}

final class ForcastAPIClient: APIClient {
  
  var configuration: NSURLSessionConfiguration
  
  // first time session is called it will execute the closure and create a session
  // using the configuration stored property, this is used offen when we need to customize
  // a value before assigning it
  lazy var session: NSURLSession = {
    return NSURLSession(configuration: self.configuration)
  }()
  
  // API Key
  private let token: String
  
  init(config: NSURLSessionConfiguration, APIKey: String) {
    self.configuration = config
    self.token = APIKey
  }
  
  convenience init(APIKey: String) {
    self.init(config: NSURLSessionConfiguration.defaultSessionConfiguration(), APIKey: APIKey)
  }
  
  func fetchCurrentWeather(coordinate: Coordinate, completion: APIResult<CurrentWeather> -> Void) {
    let request = Forecast.Current(token: self.token, coordinate: coordinate).request
    fetch(request, parse: { (JSON) -> CurrentWeather? in
      // parse from JSON response to current weather
      if let currentWeatherDictionary = JSON["currently"] as? [String : AnyObject] {
         return CurrentWeather(json: currentWeatherDictionary)
      } else {
        return nil
      }
      }, completion: completion)
  }
  
}