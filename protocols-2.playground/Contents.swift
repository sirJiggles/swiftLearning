protocol Printable {
  func description() -> String
}

protocol PrityPrintable: Printable {
  func pretyDescription() -> String
}

struct User: PrityPrintable {
  let name: String
  let age: Int
  let address: String
  
  func description() -> String {
    return "\(name),\(age),\(address)"
  }
  
  func pretyDescription() -> String {
    return "name: \(name)\nage:\(age)\naddress:\(address)"

  }
}

let user = User(name: "gareth", age: 31, address: "Some place")

print(user.pretyDescription())

// if can do protocal they have -able 
// so comparABLE nameABLE equateABLE these are all CAN DO types of protocols
// so obj can do comparisons === compareABLE

// if IS A protocol
// -type, integerTYPE collectionTYPE these are mainly in standard library

// CAN BE -convertable protocols, behaviour where one tyoe can be convertred to another
// eg in standard libraray we have nilLiteralConvertable any type that implements an init that can be nil
// for example optionals can be nil on init as they conform to this and have an init function that allows
// us to create optionals as nil to begin with


//----------------------------------------------------------------------------------//
enum Direction {
  case Up, Down, Right, Left
}


protocol Moveable {
  func move(direction: Direction, distance: Int)
}

protocol Distructable {
  func decreaseLife(factor: Int)
}

protocol Attackable {
  var strength: Int{ get }
  var range: Int{ get }
  
  func attack(player: PlayerType)
}

protocol PlayerType {
  var position: Point{ get set }
  var life: Int { get set }
  
  init(point: Point)
}


struct Point {
  let x: Int
  let y: Int
  
  func pointsAroundMe(withRange range: Int) -> [Point] {
    var results: [Point] = []
    
    for x in (self.x - range)...(self.x + range) {
      for y in (self.y - 1)...(self.y + 1) {
        let point = Point(x: x, y: y)
        results.append(point)
      }
    }
    
    return results
  }
}
