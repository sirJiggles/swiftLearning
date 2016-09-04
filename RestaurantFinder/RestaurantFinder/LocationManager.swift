//
//  LocationManager.swift
//  RestaurantFinder
//
//  Created by Gareth on 30/08/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation
import CoreLocation

extension Coordinate {
    init(location: CLLocation) {
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    
    var onLocationFix: (Coordinate -> Void)?
    
    // override the init of NSObject as we are now subclassing
    override init() {
        // call super as we are overriding
        super.init()
        // set the delegate to be this class
        manager.delegate = self
        
        manager.requestLocation()
        
        // can set to other location status, higher the acuuracy, longer it takes and more battery it uses
//        manager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func getPermission() {
        // dont ask if already have permission
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            
            // ask for permission
            manager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: CLLocationManagerDelegate implementations
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            // have location
            
            // start location updates
            manager.requestLocation()
        }
    }
    
    // could not get location
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // CAN inform via alert for example
        print(error.description)
    }
    
    // new location data!
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let coordinate = Coordinate(location: location)
        if let onLocationFix = onLocationFix {
            onLocationFix(coordinate)
        }
        
    }
    
}
