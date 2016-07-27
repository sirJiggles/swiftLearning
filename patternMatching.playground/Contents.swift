enum Coin:Double {
  case Penny = 0.01
  case Nickel = 0.05
  case Dime = 0.1
  case Quarter = 0.25
}

let wallet: [Coin] = [.Penny, .Nickel, .Dime, .Dime, .Quarter, .Quarter, .Quarter]

var count: Int = 0

for coin in wallet {
  switch(coin) {
  case .Quarter: count += 1
  default: continue
  }
}

// this is the same as the above!
for case .Quarter in wallet {
  count += 1
}

// more syntax sugar, ifs can do cool things on cases
for coin in wallet {
  if case .Nickel = coin {
    print ("not so much")
  } else if case .Dime = coin {
    print ("it is dome")
  }
}

// as optionals are enums we can do this
let someOptional: Int? = 42

// as optional is enum we check if it has the some case (not the none case) if it does we assign x
// this is what if let does!
if case .Some(let x) = someOptional {
  print(x)
}

// Nil coalessing operator
let firstName: String? = "Gareth"
let userName: String = "sirJiggles"

var displayName: String

if firstName != nil {
  displayName = firstName!
} else {
  displayName = userName
}

// lets do above as ternary / elvis
// shit thing is we have to use the bang operator
displayName = (firstName != nil) ? firstName! : userName

// this is where she comes in, sugar for ternary without force unwrapping
displayName = firstName ?? userName


