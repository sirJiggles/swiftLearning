//
//  RestaurantCell.swift
//  RestaurantFinder
//
//  Created by Gareth on 30/08/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit

// get an instance of this on every instance of prototype cell
class RestaurantCell: UITableViewCell {
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantCategoryLabel: UILabel!
    @IBOutlet weak var restaurantCheckinLabel: UILabel!
    
}
