class Employee {
  var name: String
  
  init(name: String) {
    self.name = name
  }
}

class HourlyEmployee: Employee {
  let hourlyWage: Double
  var hoursWorked: Double
  
  init(name: String, hourlyWage wage: Double, hoursWorked hours: Double) {
    self.hourlyWage = wage
    self.hoursWorked = hours
    super.init(name: name)
  }
  
  func payWages() -> Double {
    return hourlyWage * hoursWorked
  }
}

class SalariedEmployee: Employee {
  let salary: Double
  
  init(name: String, salary: Double) {
    self.salary = salary
    super.init(name: name)
  }
  
  func paySalery() -> Double {
    return salary
  }
}

let employees = [
  HourlyEmployee(name: "One", hourlyWage: 12.000, hoursWorked: 20),
  SalariedEmployee(name: "Two", salary: 30.000),
  SalariedEmployee(name: "Three", salary: 40.0000)
]

for employee in employees {
  // type check operator, returns tru if matches false if not
  if employee is HourlyEmployee {
    // this is the downcasting
    let hourlyEmployee = employee as! HourlyEmployee
    hourlyEmployee.payWages()
  }
  
  if employee is SalariedEmployee {
    if let salariedEployee = employee as? SalariedEmployee {
      salariedEployee.paySalery()
    }
  }
  
  // to work with the sub type we an use as, allows to cast to one of subclasses.
  // called downCasting as we come from the base at the top to sub class we go down
  // the tree. Some times does not work so use ! for force and ? for might work
  // only use ! when you know it will work, like after using the type check operator
  
}