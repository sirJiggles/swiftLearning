//
//  ParameterEncoding.swift
//
//  Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

extension String {
  func queryStringByAddingPercentEncoding() -> String {
    return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
  }
}

let testString = "<>%#"

testString.queryStringByAddingPercentEncoding()

func encode(paramaters: [String:AnyObject]) -> String {
  var components = [(String, String)]()
  
  // < is assending
  let sortedKeys = paramaters.keys.sort(<)
  
  for key in sortedKeys {
    let value = paramaters[key]!
    components.appendContentsOf(queryComponents(key, value: value))
  }
  
  let encodedComponents = components.map { "\($0)=\($1)" } as [String]
  
  return encodedComponents.joinWithSeparator("&")
}

func queryComponents(key: String, value: AnyObject) -> [(String, String)] {
  // create array to hold return type
  var components = [(String, String)]()
  
  if let dictionary = value as? [String: AnyObject] {
    for (nestedKey, value) in dictionary {
      let nestedComponents = queryComponents("\(key)[\(nestedKey)]", value: value)
      components.appendContentsOf(nestedComponents)
    }
  } else if let array = value as? [AnyObject] {
    for value in array {
      let nestedComponents = queryComponents("\(key)[]", value: value)
      components.appendContentsOf(nestedComponents)
    }
  } else {
    let encodedKey = key.queryStringByAddingPercentEncoding()
    let encodedValue = "\(value)".queryStringByAddingPercentEncoding()
    
    let component = (encodedKey, encodedValue)
    components.append(component)
  }
  
  return components
}



let params = ["foo": "<>test123", "baz": "#thing"]
encode(params)

let newparams = ["foo": ["bar": "something"]]
encode(newparams)

let arrayExample = ["foo": ["1", true, "thing"]]
encode(arrayExample)


















