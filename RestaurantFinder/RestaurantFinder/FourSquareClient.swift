//
//  FourSquareClient.swift
//  RestaurantFinder
//
//  Created by Gareth on 29/08/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation


enum FourSquare: Endpoint {
    case Venues(VenueEndPoint)
    
    enum VenueEndPoint: Endpoint {
        case Search(clientId: String, clientSecret: String, coordinate: Coordinate, category: Category, query: String?, searchRadius: Int?, limit: Int?)
        
        enum Category: CustomStringConvertible {
            case Food([FoodCategory]?)
            
            enum FoodCategory: String {
                case Afghan = "503288ae91d4c4b30a586d67"
            }
            
            var description: String {
                switch self {
                case .Food(let categories):
                    if let categories = categories {
                        
                        // Reduce high order function takes all and combines
                        let commaSeperatedString = categories.reduce("") { categoryString, category in
                            "\(categoryString), \(category.rawValue)"
                        }
                        
                        // remove the first comma (as first iteration
                        return commaSeperatedString.substringFromIndex(commaSeperatedString.startIndex.advancedBy(1))
                        
                    } else {
                        // categories array is empty so get top level food
                        return "4d4b7105d754a06374d81259"
                    }
                }
            }
        }
        
        // MARK: Venue Endpoint - Endpoint
        
        var baseURL: String {
            return "https://api.foursquare.com"
        }
        
        var path: String {
            switch self {
                // path to the search end piont
            case .Search: return "/v2/venues/search"
            }
        }
        
        // params based on the foursquare API
        
        private struct ParameterKeys {
            static let clientID = "client_id"
            static let clientSecret = "client_secret"
            static let version = "v"
            static let category = "categoryId"
            static let location = "ll"
            static let query = "query"
            static let limit = "limit"
            static let searchRadius = "radius"
        }
        
        private struct DefaultValues {
            static let version = "20160301"
            static let limit = "50"
            static let searchRadius = "2000"
        }
        
        var parameters: [String : AnyObject] {
            switch self {
            case .Search(let clientId, let clientSecret, let coordinate, let category, let query, let searchRadius, let limit):
                var parameters: [String: AnyObject] = [
                    ParameterKeys.clientID: clientId,
                    ParameterKeys.clientSecret: clientSecret,
                    ParameterKeys.version: DefaultValues.version,
                    ParameterKeys.location: coordinate.description,
                    ParameterKeys.category: category.description
                ]
                
                if let searchRadius = searchRadius {
                    parameters[ParameterKeys.searchRadius] = searchRadius
                } else {
                    parameters[ParameterKeys.searchRadius] = DefaultValues.searchRadius
                }
                
                if let limit = limit {
                    parameters[ParameterKeys.limit] = limit
                } else {
                    parameters[ParameterKeys.limit] = DefaultValues.limit
                }
                
                if let query = query {
                    parameters[ParameterKeys.query] = query
                }
                
                return parameters
            }
        }
        
    }
    
    // MARK: Foursquare - Endpoint
    
    var baseURL: String {
        switch self {
        case .Venues(let endpoint):
            return endpoint.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .Venues(let endpoint):
            return endpoint.path
        }
    }
    
    var parameters: [String : AnyObject] {
        switch self {
        case .Venues(let endpoint):
            return endpoint.parameters
        }
    }
    
}


final class FourSquareClient: APIClient {
    
    var configuration: NSURLSessionConfiguration
    lazy var session: NSURLSession = {
        return NSURLSession(configuration: self.configuration)
    }()
    
    let clientId: String
    let clientSecret: String
    
    init(configuration: NSURLSessionConfiguration, clientId: String, clientSecret: String) {
        self.clientSecret = clientSecret
        self.clientId = clientId
        self.configuration = configuration
    }
    
    convenience init(clientId: String, clientSecret: String) {
        self.init(configuration: .defaultSessionConfiguration(), clientId: clientId, clientSecret: clientSecret)
    }
    
    // wrapper function to 
    func fetchRestaurantsFor(
        location: Coordinate,
        category: FourSquare.VenueEndPoint.Category,
        query: String? = nil,
        searchRadius: Int? = nil,
        limit: Int? = nil,
        completion: APIResult<[Venue]> -> Void) {
        
        let searchEndPoint = FourSquare.VenueEndPoint.Search(clientId: self.clientId, clientSecret: self.clientSecret, coordinate: location, category: category, query: query, searchRadius: searchRadius, limit: limit)
        
        let endpoint = FourSquare.Venues(searchEndPoint)
        
        fetch(endpoint, parse: { (json) -> [Venue]? in
            
            guard let venues = json["response"]?["venues"] as? [[String: AnyObject]] else {
                return nil
            }
            
            // handle add each instance to array then return array
            // flat map has special overload for optionals
            // it removes all nil and returns only non optional values
            return venues.flatMap { venueDict in
                return Venue(JSON: venueDict)
            }
            
        }, completion: completion)
    }
}






