//
//  APIClient.swift
//  Stormy
//
//  Created by Gareth on 21/08/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation

typealias JSON = [String: AnyObject]
typealias JSONTaskCompletion = (JSON?, NSHTTPURLResponse?, NSError?) -> Void
typealias JSONTask = NSURLSessionDataTask

enum APIResult<T> {
  case Sucess(T)
  case Failure(ErrorType)
}

protocol APIClient {
  var configuration: NSURLSessionConfiguration { get }
  var session: NSURLSession { get }
  
  init(config: NSURLSessionConfiguration)
  
  func JSONTaskWithRequest(request: NSURLRequest, completion: JSONTaskCompletion) -> JSONTask
  
  func fetch<T>(request: NSURLRequest, parse: JSON -> T?, )
}
