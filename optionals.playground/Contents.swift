
struct Person {
  // couple of storred properties
  let firstName: String
  // middle name is optional
  // variation of existing type that allows it to be nil (BAM optionals)
  let middleName: String?
  let lastName: String
  
  // bad force unwrap!
//  func getFullName() -> String {
//    return firstName + " " + middleName! + " " + lastName
//  }
  
  // better optional binding method
}

let me = Person(firstName: "Gareth", middleName: nil, lastName: "Fuller")

//me.getFullName()

let airportCodes = ["someting": "value"]

// how to unwrap nil
//let newYork = airportCodes["not existing"]

// optional binding with if let woop woop
if let newYork = airportCodes["not existing"] {
  print("found it")
} else {
  // handle the nily from phily 
  print("handle it like a boss")
}

// handle optional pyramid of doom!

// deifne a sub dictionary
let subThing: [String: [String: String]] = [
  "gareth": ["rocks":"yes"],
  "lisa": ["rocks": "even more"]
]

// this is the pyramid to which they all bable, all hail
if let gareth = subThing["gareth"] {
  if let rocks = gareth["rocks"] {
    // finally unwrap the optional
    print(rocks)
  }
}

// BETER, multiple check where each relies on the one in the chain before it
// great for optional unwrapping of sub items that may be nil
if let lisa = subThing["lisa"], let rocks = lisa["rocks"] {
  print(rocks)
}

//struct Friend {
//  let name: String
//  let age: String
//  let address: String?
//  
//  // just like a web API
//  func createFriend(dict: [String:String]) -> Friend? {
//    
//    // this style is ... okay but it has issues when you have more than one optional as 
//    // you end up nesting your assignments and optional unwrappers. coming up tomorrow, early exits :D
//    if let name = dict["name"], let age = dict["age"]{
//      let address = dict["address"]
//      return Friend(name: name, age: age, address: address)
//    } else {
//      return nil
//    }
//  }
//}

// guards, use constant created outside the normal flow WITHOUT TRANSFERING CONTROL :D
// it is an early exit construct
// guard let someValue = someOptional else { return nil }

struct Friend {
  let name: String
  let age: String
  let address: String?
  
  // just like a web API
  func createFriend(dict: [String:String]) -> Friend? {
    
    guard let name = dict["name"], age = dict["age"] else {
      return nil
    }
    let address = dict["address"]
    
    return Friend(name: name, age: age, address: address)
    
//    if let name = dict["name"], let age = dict["age"]{
//      let address = dict["address"]
//      return Friend(name: name, age: age, address: address)
//    } else {
//      return nil
//    }
  }
}


struct Book {
  let title: String
  let author: String
  let price: String?
  let pubDate: String?
  
  init?(dict:[String:String]){
    guard let title = dict["title"], author = dict["author"] else {
      return nil
    }
    self.title = title
    self.author = author
    self.price = dict["price"]
    self.pubDate = dict["pubDate"]
  }
}

