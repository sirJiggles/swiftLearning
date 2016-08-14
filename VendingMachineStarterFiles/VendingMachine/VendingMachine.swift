//
//  VendingMachine.swift
//  VendingMachine
//
//  Created by Gareth Fuller on 02/08/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation
import UIKit

// Protocals

protocol VendingMachineType {
  var selection:[VendingSelection] { get }
  var inventory:[VendingSelection: ItemType] { get set }
  var amountDeposited:Double { get set }
  
  init(inventory: [VendingSelection:ItemType])
  
  func itemForCurrentSelection(selection:VendingSelection) -> ItemType?
  func vend(selection:VendingSelection, quantity: Double) throws
  func deposit(amount: Double)
}

protocol ItemType {
  var price: Double { get }
  var quantity: Double { get set }
}

// Error types

enum InventoryError: ErrorType {
  case InvaidResourceError
  case ConversionError
  case InvalidKey
}

enum VendingMachineError: ErrorType {
  case InvalidSelection
  case OutOfStock
  case InsufficientFunds(required: Double)
}

// Helper Classes, class because it does things
class PlistConverter {
  
  class func dictonaryFromFile(resource:String, ofType type :String) throws -> [String: AnyObject] {
    // get a path to the resource
    
    guard let path = NSBundle.mainBundle().pathForResource(resource, ofType: type) else {
      throw InventoryError.InvaidResourceError
    }
    
    guard let dictionary = NSDictionary(contentsOfFile: path), let castDictionary = dictionary as? [String:AnyObject] else {
      throw InventoryError.ConversionError
    }
    
    return castDictionary
    
  }
  
  // type methods in classes are defined like so
//  class func someFunc() {
//    
//  }
  // then you would call with: PrintConverter.someFunc()
  // if done on struct it is "static func"
  // instances only need to be created to keep track of data that can change over time
  // but our plist cinverter does not need to hang on to the data so, there is no need for instance
  // stand alone functions also do not convay purpose and do not scope well
}

class InventoryUnArchiver {
  class func vendingInventoryFromDictrionary(dictionary: [String: AnyObject]) throws -> [VendingSelection:ItemType] {
    
    var inventory: [VendingSelection: ItemType] = [:]
    
    for (key, value) in dictionary {
      if let itemDict = value as? [String:Double], let price = itemDict["price"], let quantity = itemDict["quantity"] {
        
        let item = VendingItem(price: price, quantity: quantity)
        
        guard let key = VendingSelection(rawValue: key) else {
          throw InventoryError.InvalidKey
        }
        
        inventory.updateValue(item, forKey: key)
        
      }
    }
    
    return inventory
    
  }
}

// Concreate types

enum VendingSelection: String {
  case Soda
  case DietSoda
  case Chips
  case Cookie
  case Sandwich
  case Wrap
  case CandyBar
  case PopTart
  case Water
  case FruitJuice
  case SportsDrink
  case Gum
  
  func icon() -> UIImage {
    if let image = UIImage(named: self.rawValue) {
      return image
    } else {
      return UIImage(named: "Default")!
    }
  }
}

struct VendingItem: ItemType {
  var price: Double
  var quantity: Double
}

class VendingMachine: VendingMachineType {
  let selection: [VendingSelection] = [.Soda, .DietSoda, .Chips, .Cookie, .Sandwich, .Wrap, .CandyBar, .PopTart, .Water, .FruitJuice, .SportsDrink, .Gum]
  var inventory: [VendingSelection: ItemType]
  var amountDeposited: Double = 10
  
  // required as required by the protocol
  required init(inventory: [VendingSelection:ItemType]) {
    self.inventory = inventory
  }
  
  // convinence function that gives context so code becomes more readable
  func itemForCurrentSelection(selection:VendingSelection) -> ItemType? {
    return inventory[selection]
  }

  func deposit(amount: Double) {
    amountDeposited += amount
  }
  
  func vend(selection: VendingSelection, quantity: Double) throws {
    guard var item = inventory[selection] else {
      throw VendingMachineError.InvalidSelection
    }
    
    guard item.quantity > 0 else {
      throw VendingMachineError.OutOfStock
    }
    
    // update the quantity of this item
    item.quantity -= quantity
    
    // update the inventory dicts item (with this new quantity)
    inventory.updateValue(item, forKey: selection)
    
    let totalPrice:Double = item.price * quantity
    
    if amountDeposited >= totalPrice {
      amountDeposited -= totalPrice
    } else {
      let amountRequired = totalPrice - amountDeposited
      throw VendingMachineError.InsufficientFunds(required: amountRequired)
    }
    
  }

}