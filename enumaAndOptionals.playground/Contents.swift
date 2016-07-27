
let week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

// old strings version
func weekDayOrWeekend(day: String) -> String {
  switch day {
    case "Saturday", "Sunday": return "Weekend"
    case "Monday", "Tuesday", "Wednesday", "Thursday", "Friday": return "Weekday"
    default: return "not valid"
  }
}
func muteNotifications(day: String) -> Bool {
  if day == "Weekend" {
    return true
  } else {
    return false
  }
}

// enums are uppercase and singular
enum Day {
  case Monday
  case Tuesday
  case Wednesday
  case Thursday
  case Friday
  case Saturday
  case Sunday
}

enum DayType {
  case Weekday
  case Weekend
}

func weekDayOrWeekend(day: Day) -> DayType {
  switch day {
  case .Saturday, .Sunday: return .Weekend
  default: return .Weekday
  }
}

func muteNotifications(dayType: DayType) -> Bool {
  switch dayType {
  case .Weekday:
    return false
  case .Weekend:
    return true
  }
}

let result = weekDayOrWeekend(Day.Sunday)
let isMuted = muteNotifications(result)

// even though we have the same function name we can use both, this is FUNCTION OVERLOADING in swift the autocomplete will give you both implementayions as long as they accept different arguments



// Color Objects example enums with associated values
import UIKit

enum ColorComponents {
  case RGB(red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)
  case HSB(CGFloat, CGFloat, CGFloat, CGFloat)
  
  // get ui color obj
  func color() -> UIColor {
    switch(self) {
      // values here are associated to the local constance when method is called on instance
    case .RGB(let redValue, let greenValue, let blueValue, let alphaValue):
      return UIColor(red: redValue/255.0, green: greenValue/255.0, blue: blueValue/255.0, alpha: alphaValue)
    case .HSB(let hueValue, let saturationValue, let brightnessValue, let alphaValue):
      return UIColor(hue: hueValue/360.0, saturation: saturationValue/100.0, brightness: brightnessValue/100.0, alpha: alphaValue)
    }
  }
}

ColorComponents.RGB(red:61.0, green:120.0, blue:198.0, alpha:1.0).color()

// POPULATING WITH DEFAULTS - RAW VALUES, need to be the same type

enum Coin:Double {
  case Penny = 0.01
  case Nickel = 0.05
  case Dime = 0.1
  case Quarter = 0.25
}

let coins: [Coin] = [.Penny, .Nickel, .Dime, .Dime, .Quarter, .Quarter, .Quarter]

func totalValue(coins: [Coin]) -> Double {
  var total: Double = 0
  for coin in coins {
//    switch coin {
//      // value of the enum does not chage as in penny is alawys 0.01
//    case .Penny: total += 0.01
//    case .Nickel: total += 0.05
//    case .Dime: total += 0.1
//    case .Quarter: total += 0.25
//    }
    // this replaces entire switch case
    total += coin.rawValue
  }
  return total
}

totalValue(coins)

//Raw value intializers
enum Status: Int {
  case Success = 200
  case NotFound = 404
}

let state = 404
// use raw value to get the correct enum else nil so is optional (failable initilizer)
if let code = Status(rawValue: state) {
  print(code)
}

enum Compass: Int {
  case North = 1
  case South
  case East
  case West
}

let direction = Compass(rawValue: 3)








