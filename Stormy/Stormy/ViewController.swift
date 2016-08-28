//
//  ViewController.swift
//  Stormy
//
//  Created by Pasan Premaratne on 4/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit

extension CurrentWeather {
  var temperatureString: String {
    return "\(Int(temperature))º"
  }
  var humidyString: String {
    let percentageValue = Int(humidity * 100)
    return "\(percentageValue)%"
  }
  var chanceOfRainString: String {
    let percentageValue = Int(chaceOfRain * 100)
    return "\(percentageValue)%"
  }
}

class ViewController: UIViewController {
    
  @IBOutlet weak var currentTemperatureLabel: UILabel!
  @IBOutlet weak var currentHumidityLabel: UILabel!
  @IBOutlet weak var currentPrecipitationLabel: UILabel!
  @IBOutlet weak var currentWeatherIcon: UIImageView!
  @IBOutlet weak var currentSummaryLabel: UILabel!
  @IBOutlet weak var refreshButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  lazy var forcastApiClient = ForcastAPIClient(APIKey: "72ea492007fe70f0b1813057a678ef51")
  
  let coordinate = Coordinate(latitude: 50.165712, longitude: 8.569069)
    

    override func viewDidLoad() {
      super.viewDidLoad()
      
//      let icon = WeatherIcon.PartlyCloudyDay.image
//      let currentWeather = CurrentWeather(temperature: 56.0, humidity: 0.3, chaceOfRain: 0.4, summary: "This is some text", icon: icon)
      
      forcastApiClient.fetchCurrentWeather(coordinate) { result in
        switch result {
        case .Sucess(let currentWeather):
          self.display(currentWeather)
        case .Failure(let error as NSError):
          self.showAlert("Unable to recieve forcast", message: error.localizedDescription)
        default: break
        }

      }
      
      
//      let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(forcastAPIKey)/")
//      let forcastURL = NSURL(string: "50.165712,8.569069", relativeToURL: baseURL)
      
      // This is how you would get it syncronously and block the UI (main thread)
      // you should do it in a background thread and not block the UI
//      
//      let weatherData = NSData(contentsOfURL: forcastURL!)
//      
//      let json = try! NSJSONSerialization.JSONObjectWithData(weatherData!, options: []) as! [String: AnyObject]
      
//      let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
//      let session = NSURLSession(configuration: configuration)
//      
//      let request = NSURLRequest(URL: forcastURL!)
//      
//      // here task is already added to the session
//      let dataTask = session.dataTaskWithRequest(request, completionHandler: { data, response, error in
//        print(data!)
//      })
//      
//      // actually runs the HTTP request
//      dataTask.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func display(weather: CurrentWeather) {
    currentTemperatureLabel.text = weather.temperatureString
    currentPrecipitationLabel.text = weather.chanceOfRainString
    currentHumidityLabel.text = weather.humidyString
    currentSummaryLabel.text = weather.summary
    currentWeatherIcon.image = weather.icon
  }
  
  func showAlert(title: String, message: String?, style: UIAlertControllerStyle = .Alert) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
    let dismissAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alertController.addAction(dismissAction)
    presentViewController(alertController, animated: true, completion: nil)
  }


}

