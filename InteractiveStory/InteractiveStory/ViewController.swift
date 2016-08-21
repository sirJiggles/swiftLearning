//
//  ViewController.swift
//  InteractiveStory
//
//  Created by Gareth Fuller on 14/08/16.
//  Copyright © 2016 Gareth Fuller. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
  
  enum Error:ErrorType {
    case NoName
  }
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var TextFieldBottomContraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // return singleton for notification center
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
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
        fatalError()
      }
      
      
    }
  }
    
  func keyboardWillShow(notifcation: NSNotification) {
    if let userInfoDictionary = notifcation.userInfo, keyboardFrameValue = userInfoDictionary[UIKeyboardFrameEndUserInfoKey] as? NSValue {
      // convert from ns value to cgrect
      let keyboardFrame = keyboardFrameValue.CGRectValue()
      
      UIView.animateWithDuration(0.8, animations: {
        self.TextFieldBottomContraint.constant = keyboardFrame.size.height - 60
        self.view.layoutIfNeeded()
      })
      
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    UIView.animateWithDuration(0.8, animations: {
      // back to original setting
      self.TextFieldBottomContraint.constant = 40.0
      self.view.layoutIfNeeded()
    })
  }
  
  // prior iOS 9, this is auto removed in newer versions!, so uncomment for now
//  deinit {
//    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
//  }
  
  // MARK: - UITextFieldDelegate
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

