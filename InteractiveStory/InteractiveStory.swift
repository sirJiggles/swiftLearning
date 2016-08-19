//
//  InteractiveStory.swift
//  InteractiveStory
//
//  Created by Gareth Fuller on 15/08/16.
//  Copyright © 2016 Gareth Fuller. All rights reserved.
//

import Foundation
import UIKit

enum Story {
  case ReturnTrip(String)
  case TouchDown
  case Homeward
  case Rover(String)
  case Cave
  case Crate
  case Monster
  case Droid(String)
  case Home
  
  var rawValue:String {
    switch self {
    case .ReturnTrip: return "ReturnTrip"
    case .TouchDown: return "TouchDown"
    case .Homeward: return "Homeward"
    case .Rover: return "Rover"
    case .Cave: return "Cave"
    case .Crate: return "Crate"
    case .Monster: return "Monster"
    case .Droid: return "Droid"
    case .Home: return "Home"
    }
  }
}


extension Story {
  // computed property
  var artwork: UIImage {
    return UIImage.init(named: self.rawValue)!
  }
  var text: String {
    switch self {
    case .ReturnTrip(let name):
      return "On your return trip from studying Saturn's rings, you hear a distress signal that seems to be coming from the surface of Mars. It's strange because there hasn't been a colony there in years. \"Help me \(name), you're my only hope.\""
    case .TouchDown:
      return "You deftly land your ship near where the distress signal originated. You didn't notice anything strange on your fly-by, behind you is an abandoned rover from the early 21st century and a small crate."
    case .Homeward:
      return "You continue your course to Earth. Two days later, you receive a transmission from HQ saing that they have detected some sort of anomaly on the surface of Mars near an abandoned rover. They ask you to investigate, but ultimately the decision is yours because your mission has already run much longer than planned and supplies are low."
    case .Rover(let name):
      return "The rover is covered in dust and most of the solar panels are broken. But you are quite surprised to see the on-board system booted up and running. In fact, there is a message on the screen. \"\(name), come to 28.2342, -81.08273\". These coordinates aren't far but you don't know if your oxygen will last there and back."
    case .Cave:
      return "Your EVA suit is equipped with a headlamp which you use to navigate to a cave. After searching for a while your oxygen levels are starting to get pretty low. You know you should go refill your tank, but there's a faint light up ahead."
    case .Crate:
      return "Unlike everything else around you the crate seems new and...alien. As you examine the create you notice something glinting on the ground beside it. Aha, a key! It must be for the crate..."
    case .Monster:
      return "You pick up the key and try to unlock the crate, but the key breaks off in the keyhole.You scream out in frustration! Your scream alerts a creature that captures you and takes you away..."
    case .Droid(let name):
      return "After a long walk slightly uphill, you end up at the top of a small crater. You look around and are overjoyed to see your robot friend, \(name)-S1124. It had been lost on a previous mission to Mars. You take it back to your ship and fly back to Earth."
    case .Home:
      return "You arrive home on Earth. While your mission was a success, you forever wonder what was sending that signal. Perhaps a future mission will be able to investigate."
    }
  }
}


class Page {
  let story: Story
  
  // rather than creating a new object
  // as named tupel we can use dot notation
  // tupels are anonymous strctuts so its a little nicer
  typealias Choice = (title: String, page:Page)
  
  var firstChoice: Choice?
  var secondChoice: Choice?
  
  init(story:Story) {
    self.story = story
  }
  
}

extension Page {
  
  // Methods are the same name but this is method overloading (diffent arguments)
  func addChoice(title:String, story: Story) -> Page {
    let page = Page(story: story)
    return addChoice(title, page: page)
  }
  
  func addChoice(title: String, page: Page) -> Page {
    // optionals under the hood are enums with some and none values
    // which is why we can check if they are nil like this in a cool switch case
    switch (firstChoice, secondChoice) {
    case(.Some, .Some): break
    case(.None, .None), (.None, .Some):
      firstChoice = (title, page)
    case(.Some, .None):
      secondChoice = (title, page)
    }
    return page
  }
}


struct Adventure {
  static func story(name:String) -> Page {
    let returnTrip = Page(story: .ReturnTrip(name))
    let touchdown = returnTrip.addChoice("Stop and Investigate", story: .TouchDown)
    let homeward = returnTrip.addChoice("Continue Home to Earth", story: .Homeward)
    let rover = touchdown.addChoice("Explore the Rover", story: .Rover(name))
    let crate = touchdown.addChoice("Open the Crate", story: .Crate)
    
    homeward.addChoice("Head back to Mars", page: touchdown)
    let home = homeward.addChoice("Continue Home to Earth", story: .Home)
    
    let cave = rover.addChoice("Explore the Coordinates", story: .Cave)
    rover.addChoice("Return to Earth", page: home)
    
    cave.addChoice("Continue towards faint light", story: .Droid(name))
    cave.addChoice("Refill the ship and explore the rover", page: rover)
    
    crate.addChoice("Explore the Rover", page: rover)
    crate.addChoice("Use the key", story: .Monster)
    
    return returnTrip
  }
}








