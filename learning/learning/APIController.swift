//
//  APIController.swift
//  learning
//
//  Created by Gareth Fuller on 12/06/16.
//  Copyright © 2016 Gareth Fuller. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didReceiveAPIResults(_ results: NSArray)
}

class APIController {
    
    init(delegate: APIControllerProtocol) {
        self.delegate = delegate
    }
    
    var delegate: APIControllerProtocol
    
    func searchItunesFor(_ searchTerm: String) {
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.replacingOccurrences(of: " ", with: "+", options: String.CompareOptions.caseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        if let escapedSearchTerm = itunesSearchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
            let url = URL(string: urlPath)
            let session = URLSession.shared()
            let task = session.dataTask(with: url!, completionHandler: {data, response, error -> Void in
                print("Task completed")
                if(error != nil) {
                    // If there is an error in the web request, print it to the console
                    print(error?.localizedDescription)
                }
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        if let results: NSArray = jsonResult["results"] as? NSArray {
                            self.delegate.didReceiveAPIResults(results)
                        }
                    }
                } catch let err as NSError {
                    print("JSON Error \(err.localizedDescription)")
                }
            })
            
            // The task is just an object with all these properties set
            // In order to actually make the web request, we need to "resume"
            task.resume()
        }
    }

}
