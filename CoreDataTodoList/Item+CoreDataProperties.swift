//
//  Item+CoreDataProperties.swift
//  CoreDataTodoList
//
//  Created by Gareth on 06/10/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @NSManaged public var text: String?
    @NSManaged public var completed: Bool

}
