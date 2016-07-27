//: Playground - noun: a place where people can play

class Address {
  var streetName: String?
  var house: String?
  var town: String?
}

class Residence {
  var address: Address?
}

class Person {
  var residence: Residence?
}


let lisa = Person()
let address = Address()
address.streetName = "some street"
address.house = "14"
address.town = "gmc"

let residence = Residence()
residence.address = address

lisa.residence = residence

// this is otional chaining it allows us to not have to do the masive guard or if lets
if let appartmentNumber = lisa.residence?.address?.house {
  print(appartmentNumber)
}


