// there is some method to this name madness
protocol FullyNameable {
  
  // whatever uses this protocal must have a stored prop
  // called fullname of string type that is only readable (the get)
  var fullname: String { get }
}

// conforms to protocal
struct User: FullyNameable {
  
  // implements interface
  var fullname: String
}

let user = User(fullname: "Gareth fuller")

print(user.fullname)

struct Friend: FullyNameable {
  let firstname: String
  let middlename: String
  let lastname: String
  
  // sample computed property
  var fullname: String {
    return "\(firstname) \(middlename) \(lastname)"
  }
}

let friend = Friend(firstname: "Gareth", middlename: "Dean", lastname: "Fuller")

/*************************************************************/

protocol Payable {
  func pay() -> (basePay: Double, benefits: Double, deductions: Double, vacationTime: Double)
}

import Foundation

enum EmployeeType {
  case Manager
  case NotManager
}

class Employee {
  let name: String
  let address: String
  let startDate: NSDate
  let type: EmployeeType
  
  var department: String?
  var reportsTo: String?
  
  init(fullName: String, employeeAddress: String, employeeStartDate: NSDate, employeeType: EmployeeType) {
    self.name = fullName
    self.address = employeeAddress
    self.startDate = employeeStartDate
    self.type = employeeType
  }
}

func payEmployee(employee: Payable) {
  employee.pay()
}

class HourlyEmployee: Employee, Payable {
  var hourlyWage: Double = 15.00
  var hoursWorked: Double = 0
  let availableVacation: Double = 0
  
  func pay() -> (basePay: Double, benefits: Double, deductions: Double, vacationTime: Double) {
    return(hourlyWage * hoursWorked, 0, 0, availableVacation)
  }
}

let employee = Employee(fullName: "gareth", employeeAddress: "addr", employeeStartDate: NSDate(), employeeType: .Manager)


/*************************************************************/

protocol Blandable {
  func blend()
}

class Fruit: Blandable {
  var name: String
  
  init(name: String) {
    self.name = name
  }
  
  func blend() {
    print("I am mush")
  }
}

class Dairy {
  var name: String
  
  init(name: String) {
    self.name = name
  }
}

class Cheese: Dairy {}

class Milk: Dairy, Blandable {
  func blend() {
    print("I havent changed, I am still milk!")
  }
}

// as a protocal is a type we can pass it in as a required type of param
func makeSmoothy(ingredients: [Blandable]) {
  for ingredient in ingredients {
    print("blending")
    
    // even though they are different, we can call the method we knoe they implement
    ingredient.blend()
  }
}

let straw = Fruit(name: "Strawberry")
let cheddar = Cheese(name: "Cheddar")
let chocoMilk = Milk(name: "Cocolate Milk")

// as they are different types is a obj c array, until we add type casting aka the [Blendable] then
// becomes an array of blendable types so protocols are also
let ingredients:[Blandable] = [straw, chocoMilk]

makeSmoothy(ingredients)


/*************************************************************/


