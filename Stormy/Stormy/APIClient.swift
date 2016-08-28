//
//  APIClient.swift
//  Stormy
//
//  Created by Gareth on 21/08/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation

// this is fr throwing errors in objective C, cannot throw from a closure from foundation
// the three letter prefix is to prevent conflicts, it just like JS lol!
public let TRENetworkingErrorDomain = "com.treehouse.stormy.NetworkingError"
public let MissingHTTPResponseError:Int = 10

public let UnexpectedResponseError: Int = 20

typealias JSON = [String: AnyObject]
typealias JSONTaskCompletion = (JSON?, NSHTTPURLResponse?, NSError?) -> Void
typealias JSONTask = NSURLSessionDataTask

enum APIResult<T> {
  case Sucess(T)
  case Failure(ErrorType)
}

protocol JSONDecodable {
  init?(json: [String:AnyObject])
}

protocol APIClient {
  var configuration: NSURLSessionConfiguration { get }
  var session: NSURLSession { get }
  
  init(config: NSURLSessionConfiguration, APIKey: String)
  
  func JSONTaskWithRequest(request: NSURLRequest, completion: JSONTaskCompletion) -> JSONTask
  
  func fetch<T>(request: NSURLRequest, parse: JSON -> T?, completion: APIResult<T> -> Void)
}

protocol EndPoint {
  var baseUrl: NSURL { get }
  var path: String { get }
  var request: NSURLRequest { get }
}

extension APIClient {
  
  func JSONTaskWithRequest(request: NSURLRequest, completion: JSONTaskCompletion) -> JSONTask {
    let task = session.dataTaskWithRequest(request) { data, response, error in
      guard let HTTPResponse = response as? NSHTTPURLResponse else {
        // canonot convert to http 
        let userInfo = [
          NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP response", comment: "")
        ]
        let error = NSError(domain: TRENetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
        
        completion(nil, nil, error)
        // leave the current function scope and go back to JSONTaskWithRequest
        return
      }
      
      if data == nil {
        if let error = error {
          completion(nil, HTTPResponse, error)
        }
      } else {
        switch HTTPResponse.statusCode {
        case 200:
          do {
            // can force unwrap the error as we already error check nil above
            let JSON = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String: AnyObject]
            completion(JSON, HTTPResponse, nil)
          } catch let error as NSError {
            completion(nil, HTTPResponse, error)
          }
        default:
          print("recieved response \(HTTPResponse.statusCode)")
        }
      }
    }
    
    
    return task
  }
  
  func fetch<T>(request: NSURLRequest, parse: JSON -> T?, completion: APIResult<T> -> Void) {
    let task = JSONTaskWithRequest(request, completion: { json, response, error in
      
      // pass our code to the main que
      // second argument, closure will execute on main que
      // this is GCD (grand central dispatch) like train station
      dispatch_async(dispatch_get_main_queue()) {
        guard let json = json else {
          if let error = error {
            completion(.Failure(error))
          } else {
            // this could be for example a 500
            let error = NSError(domain: TRENetworkingErrorDomain, code: UnexpectedResponseError, userInfo: nil)
            completion(.Failure(error))
          }
          return
        }
        
        // now have a valid JSON:[String:AnyObject]
        if let value = parse(json) {
          completion(.Sucess(value))
        } else {
          // hav valid JSON but in unexpeted function
          let error = NSError(domain: TRENetworkingErrorDomain, code: UnexpectedResponseError, userInfo: nil)
          completion(.Failure(error))
        }
      }
    })
    
    task.resume()
  }
}

