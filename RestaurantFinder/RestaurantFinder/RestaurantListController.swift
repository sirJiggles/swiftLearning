//
//  MasterViewController.swift
//  RestaurantFinder
//
//  Created by Pasan Premaratne on 5/4/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import MapKit

class RestaurantListController: UITableViewController, MKMapViewDelegate, UISearchResultsUpdating{
    var coordinate: Coordinate?
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var mapView: MKMapView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // set up instance of client
    let fourSquareClient = FourSquareClient(
        clientId: "FIJTZY22AWSG43KDXCSHU5OKLCQPLP1JR5IQAGZEFQ5QM1IE",
        clientSecret: "ORXIEGGJYDSGSNMHUC0JL2HJCHWT3Y42USW0MWPKQUI41G1E")
    
    // canrt use constant as wont be there at load
    var venues: [Venue] = [] {
        // computed property to update the table view when the data changes
        didSet {
            tableView.reloadData()
            addMapAnnotations()
        }
    }
    
    let manager = LocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // search bar configuration
        searchController.searchResultsUpdater = self
        
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        stackView.addSubview(searchController.searchBar)
        
        // request permission
        manager.getPermission()
        
        manager.onLocationFix = { [weak self] coordinate in
            self?.coordinate = coordinate
            
            self?.fourSquareClient.fetchRestaurantsFor(coordinate, category: .Food(nil)) { result in
                switch result {
                case .Success(let venues):
                    self?.venues = venues
                case .Failure(let error):
                    print(error)
                }
            }
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                
                // get venue and pass to detail view controller
                let venue = venues[indexPath.row]
                
                controller.venue = venue
                
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return number of items in venues
        return venues.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // have to cast it to the new restaurant cell type
        let cell = tableView.dequeueReusableCellWithIdentifier("RestaurantCell", forIndexPath: indexPath) as! RestaurantCell
        
        // each row in table view has cell use cells label to display data .. for now
        
        let venue = venues[indexPath.row]
        cell.restaurantNameLabel.text = venue.name
        cell.restaurantCheckinLabel.text = venue.checkins.description
        cell.restaurantCategoryLabel.text = venue.categoryName
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // pull to refresh
    @IBAction func refreshRestaurantData(sender: AnyObject) {
        
        if let coordinate = coordinate {
            // make new newtwork
            fourSquareClient.fetchRestaurantsFor(coordinate, category: .Food(nil)) { result in
                switch result {
                case .Success(let venues):
                    self.venues = venues
                case .Failure(let error):
                    print(error)
                }
            }

        }
        
        refreshControl?.endRefreshing()
    }
    

    
    //MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        var region = MKCoordinateRegion()
        region.center = mapView.userLocation.coordinate
        
        // Set the zoom
        region.span.latitudeDelta = 0.01
        region.span.longitudeDelta = 0.01
        
        mapView.setRegion(region, animated: true)
    }
    
    func addMapAnnotations() {
        
        removeMapAnootations()
        
        if venues.count > 0 {
            let annotations: [MKPointAnnotation] = venues.map { venue in
                let point = MKPointAnnotation()
                if let coordinate = venue.location?.coordinate {
                    point.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    point.title = venue.name
                }
                return point
            }
            
            mapView.addAnnotations(annotations)
            
        }
        
    }
    
    func removeMapAnootations() {
        if mapView.annotations.count != 0 {
            for annotation in mapView.annotations {
                mapView.removeAnnotation(annotation)
            }
        }
    }
    
    //MARK: UISearchResultsUpdating
    
    // when you add or edit text in the search bar
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let coordinate = coordinate {
            fourSquareClient.fetchRestaurantsFor(coordinate, category: .Food(nil), query: searchController.searchBar.text) { result in
                switch result {
                case .Success(let venues):
                    self.venues = venues
                case .Failure(let error):
                    print(error)
                }
            }
        }
    }

}

