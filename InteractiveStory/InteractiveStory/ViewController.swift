//
//  ViewController.swift
//  InteractiveStory
//
//  Created by Gareth Fuller on 14/08/16.
//  Copyright © 2016 Gareth Fuller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  enum Error:ErrorType {
    case NoName
  }
  
  @IBOutlet weak var nameTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "startAdventure" {
      
      do {
        if let name = nameTextField.text {
          if name == "" {
            throw Error.NoName
          }
          if let pageController = segue.destinationViewController as? PageController {
            pageController.page = Adventure.story(name)
          }
        }
      } catch Error.NoName {
        let alertController = UIAlertController(title: "Name not provided", message: "Provide a name to start the story", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertController.addAction(action)
        
        presentViewController(alertController, animated: true, completion: nil)
      } catch let error {
        fatalError(errorq)
      }
      
      
    }
  }
}

