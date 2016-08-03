//
//  VendingMachine.swift
//  VendingMachine
//
//  Created by Gareth Fuller on 02/08/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation


// Protocals

protocol VendingMachineType {
  var selection:[VendingSelection] { get }
  var inventory:[VendingSelection: ItemType] { get set }
  var amountDeposited:Double { get set }
  
  init(inventory: [VendingSelection:ItemType])
  
  func vend(selection:VendingSelection, quantity: Double) throws
  func deposit(amount: Double)
}

protocol ItemType {
  var price: Double { get }
  var quantity: Double { get set }
}

// Concreate types

enum VendingSelection {
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
}

struct VendingItem: ItemType {
  let price: Double
  let quantity: Double
}

class VendingMachine: VendingMachineType {
  let selection: [VendingSelection] = [.Soda, .DietSoda, .Chips, .Cookie, .Sandwich, .Wrap, .CandyBar, .PopTart, .Water, .FruitJuice, .SportsDrink, .Gum]
  var inventory: [VendingSelection: ItemType]
  var amountDeposited: Double = 10
  
  // required as required by the protocol
  required init(inventory: [VendingSelection:ItemType]) {
    self.inventory = inventory
  }

  func deposit(amount: Double) {
    // add code
  }
  
  func vend(selection: VendingSelection, quantity: Double) throws {
    // add code
  }

}