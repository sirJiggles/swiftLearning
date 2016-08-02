//
//  RollViewController.swift
//  Dice
//
//  Created by Jason Schatz on 11/6/14.
//  Copyright (c) 2014 Udacity. All rights reserved.
//

import UIKit

class RollViewController: UIViewController {
    /**
    * Randomly generates a Int from 1 to 6
    */
    func randomDiceValue() -> Int {
        // Generate a random Int32 using arc4Random
        let randomValue = 1 + arc4random_uniform(6)
        
        // Return a more convenient Int, initialized with the random value
        return Int(randomValue)
    }
  
    // this is how we do a prepare for segue, all UIView controllers get this function
    // and here we can prepare for a story board navigation event like clicking the button
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if let segueId = segue.identifier {
        // how we know the action is the one for this view controller to open
        if segueId == "rollDice" {
          let controller = segue.destinationViewController as! DiceViewController
          
          controller.firstValue = self.randomDiceValue()
          controller.secondValue = self.randomDiceValue()
        }
      }
      
      
    }

    @IBAction func rollTheDice() {
      /*
      * Method to get and navigate to view via story board, you need a hook to
      * story board as it needs to get the outlets and action connections
      */
      
//      var controller: DiceViewController
//      controller = self.storyboard?.instantiateViewControllerWithIdentifier("DiceViewController") as! DiceViewController
//      
//      controller.firstValue = self.randomDiceValue()
//      controller.secondValue = self.randomDiceValue()
//      
//      self.presentViewController(controller, animated: true, completion: nil)
      
      /*
      * If you want to do a manual suegway in code
      */
      //self.performSegueWithIdentifier("rollDice", sender: self)
 
    }
}

