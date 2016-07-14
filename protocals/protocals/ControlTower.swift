//
//  ControlTower.swift
//  protocals
//
//  Created by Gareth Fuller on 30/06/16.
//  Copyright © 2016 Gareth Fuller. All rights reserved.
//

import Foundation

typealias Knots = Int

struct LandingInstructions {
  let runway: ControlTower.Runway
  let terminal: ControlTower.Terminal
}


protocol Flying {
  var decentSpeed: Knots { get }
}

protocol Landing {
  func requestLandingInstrutions() -> LandingInstructions
}

protocol Airline: Flying, Landing {
  var type: AirlineType { get }
}

// This is a marker protocal, alows to create a higher type to conform lower types
protocol AirlineType: Flying {
  
}

enum DomesticAirlineType: AirlineType {
  case Delta
  case American
  case United
}

enum InternationAirlineType: AirlineType {
  case Lufthansa
  case KLM
  case AirFrance
}

// MARK controll towner

// cannot be overriden or subclassed
final class ControlTower {
  enum Runway {
    case R22l
    case L31R
    case M25J
    case B19E
    
    static func runway(speed:Knots) -> Runway {
      switch speed {
      case 0..<91:
        return .R22l
      case 91...120:
        return .L31R
      case 121...140:
        return .M25J
      case 141...165:
        return .B19E
      default:
        return .B19E
      }
    }
  }
  
  enum Terminal {
    case A(Int?)
    case B(Int?)
    case C(Int?)
    case International(Int?)
    case Private(Int?)
      
    static func terminal(airline: Airline) -> Terminal {
      switch airline.type {
      case is DomesticAirlineType:
        let domesticAirline = airline.type as! DomesticAirlineType
        switch domesticAirline {
        case .Delta:
          let gate = GateManager.sharedInstance.gateFor(terminal: .A(nil))
          return .A(gate)
        case .American:
          let gate = GateManager.sharedInstance.gateFor(terminal: .B(nil))
          return .B(gate)
        case .United:
          let gate = GateManager.sharedInstance.gateFor(terminal: .C(nil))
          return .C(gate)
        }
      case is InternationAirlineType:
        let gate = GateManager.sharedInstance.gateFor(terminal: .International(nil))
        return .International(gate)
      default:
        let gate = GateManager.sharedInstance.gateFor(terminal: .Private(nil))
        return .Private(gate)
      }
    }
  }
      
  class GateManager {
    
    // makes the class a singleton
    // have to use it like classInstance.sharedInstance
    static let sharedInstance = GateManager()
    
    // also make the init private stops people trying to get arround the singleton pattern via init
    private init() {}
    
    var gatesForTerminalA: [String: [Int]] = ["occupied": [1,2,3,4,5,6,7,8], "empty": [9,10,11,12]]
    var gatesForTerminalB: [String: [Int]] = ["occupied": [1], "empty": [2,3,4,5,6,7,8]]
    var gatesForTerminalC: [String: [Int]] = ["occupied": [1,2,3,4], "empty": [5,6,7,8,9,10]]
    var gatesForInternationalTerminal: [String: [Int]] = ["occupied": [1,2,3], "empty": [4,5,6]]
    var gatesForPrivateHangars: [String: [Int]] = ["occupied": [1], "empty": [2,3]]
    
    func update(gates: inout [String: [Int]], gate: Int) {
      // if var creates a var that can be modified
      if var occupiedGates = gates["occupied"] {
        // put the gate in the occupied list (local var)
        occupiedGates.append(gate)
        // reassign
        gates.updateValue(occupiedGates, forKey: "occupied")
      }
      
      if var emptyGates = gates["empty"], let index = emptyGates.index(of: gate) {
        emptyGates.remove(at: index)
        gates.updateValue(emptyGates, forKey: "empty")
      }
    }
    
    func emptyGate(gates: inout [String: [Int]]) -> Int? {
      guard let gate = gates["empty"]?.first else {
        return nil
      }
      
      update(gates: &gates, gate: gate)
      return gate
    }
    
    func gateFor(terminal: Terminal) -> Int? {
      switch terminal {
      case .A:
        return emptyGate(gates: &gatesForTerminalA)
      case .B:
        return emptyGate(gates: &gatesForTerminalB)
      case .C:
        return emptyGate(gates: &gatesForTerminalC)
      case .Private:
        return emptyGate(gates: &gatesForPrivateHangars)
      case .International:
        return emptyGate(gates: &gatesForInternationalTerminal)
      }
    }
  }
    
    
  func land(airline: Airline) -> LandingInstructions {
    let runway = Runway.runway(speed: airline.decentSpeed)
    let terminal = Terminal.terminal(airline: airline)
    return LandingInstructions(runway: runway, terminal: terminal)
  }
}

// when we create a new type that coforms to the protocal
// each instance will get this implementation by default and remove repeated code
extension Airline {
  var decentSpeed: Knots {
    return type.decentSpeed
  }
  func requestLandingInstrutions() -> LandingInstructions {
    return ControlTower().land(airline: self)
  }
  
}

extension DomesticAirlineType {
  var decentSpeed: Knots {
    return 100
  }
}

extension InternationAirlineType {
  var decentSpeed: Knots {
    return 130
  }
}

struct Flight: Airline {
  let type: AirlineType
}





