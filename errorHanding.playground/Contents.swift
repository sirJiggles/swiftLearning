
struct Friend {
  let name: String
  let age: String
  let address: String?
}

// conform to the error type protocol, is empty
// so we dont need to implement anything, but its recognised as valid error type
// enums make sense as we can model each error as member
enum FriendError: ErrorType {
  case InvalidData(String)
  case NetworkError
}

// the throws in the func declaration means this func can throw an error
func createFriendFromJSON(dict: [String:String]) throws -> Friend {
  
  // this is where we throw the error, because of this we dont need optional friend as return
  // as we will throw an error and exit the function
  guard let name = dict["name"] else {
    throw FriendError.InvalidData("Name failed")
  }
  
  guard let age = dict["age"] else {
    throw FriendError.InvalidData("Age failed")
  }

  
  let address = dict["address"]
  
  return Friend(name: name, age: age, address: address)
  
}

//this is an example of something that depends on throw
func sendMessageToFriend(friend: Friend, message: String) {
  
}

let response: [String:String] = ["name": "Gareth", "ages": "31", "address": "sdsdsd"]

// NONE OF THE BELLOW IS RUN AS WE SPELT AGE WRONG

// the try is to try call a function that throws
//let friend = try createFriendFromJSON(response)
//
//print(friend.name)

do {
  // when error it will bubble up to nearest catch
  let friend = try createFriendFromJSON(response)
  print(friend.name)
} catch FriendError.InvalidData(let property) {
  print(property)
} catch FriendError.NetworkError() {
  // this could also happen
}


enum ParserError: ErrorType {
  case EmptyDictionary
  case InvalidKey
}

struct Parser {
  var data: [String : String?]?
  
  func parse() throws {
    guard let data = self.data else {
      throw ParserError.EmptyDictionary
    }
    guard let key = data["someKey"] else {
      throw ParserError.InvalidKey
    }
  }
}

let data: [String : String?]? = ["someKey": nil]
do {
  let parser = Parser(data: data)
  try parser.parse()
} catch ParserError.InvalidKey(let err) {
  print(err)
} catch ParserError.EmptyDictionary(let err) {
  print(err)
}

