//
//  ViewController.swift
//  learning
//
//  Created by Gareth Fuller on 12/06/16.
//  Copyright © 2016 Gareth Fuller. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    @IBOutlet var appsTableView : UITableView!
    
    var tableData = []
    var imageCache = [String:UIImage]()
    
    // reusable search result cell
    let kCellIdentifier: String = "SearchResultCell"
    
    var api: APIController!

    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        api.searchItunesFor("Ruckus")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the row data for the selected row
        if let rowData = self.tableData[(indexPath as NSIndexPath).row] as? NSDictionary,
            // Get the name of the track for this row
            name = rowData["trackName"] as? String,
            // Get the price of the track on this row
            formattedPrice = rowData["formattedPrice"] as? String {
            let alert = UIAlertController(title: name, message: formattedPrice, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier)! as UITableViewCell
        
        if let rowData: NSDictionary = self.tableData[(indexPath as NSIndexPath).row] as? NSDictionary,
            // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
            urlString = rowData["artworkUrl60"] as? String,
            // Create an NSURL instance from the String URL we get from the API
            imgURL = NSURL(string: urlString),
            // Get the formatted price string for display in the subtitle
            formattedPrice = rowData["formattedPrice"] as? String,
            // Get the track name
            trackName = rowData["trackName"] as? String {
                // Get the formatted price string for display in the subtitle
                cell.detailTextLabel?.text = formattedPrice
                // Update the imageView cell to use the downloaded image data
                cell.imageView?.image = UIImage(named: "PUGME")
            
                // Update the textLabel text to use the trackName from the API
                cell.textLabel?.text = trackName
            
                // If this image is already cached, don't re-download
                if let img = imageCache[urlString] {
                    cell.imageView?.image = img
                }
                else {
                    // The image isn't cached, download the img data
                    // We should perform this in a background thread
                    let request: URLRequest = URLRequest(url: imgURL as URL)
                    //let mainQueue = NSOperationQueue.mainQueue()
                    let session = URLSession(configuration: URLSessionConfiguration.default())
                    let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                        if error == nil {
                            // Convert the downloaded data in to a UIImage object
                            let image = UIImage(data: data!)
                            // Store the image in to our cache
                            self.imageCache[urlString] = image
                            // Update the cell
                            DispatchQueue.main.async(execute: {
                                if let cellToUpdate = tableView.cellForRow(at: indexPath) {
                                    cellToUpdate.imageView?.image = image
                                }
                            })
                        }
                        else {
                            print("Error: \(error!.localizedDescription)")
                        }
                    })
                    task.resume()
                }
            
        }
        return cell
    }
    
    func didReceiveAPIResults(_ results: NSArray) {
        DispatchQueue.main.async(execute: {
            self.tableData = results
            self.appsTableView!.reloadData()
        })
    }
    
}

