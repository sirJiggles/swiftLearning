//
//  ViewController.swift
//  defaultModalViews
//
//  Created by Gareth Fuller on 31/07/16.
//  Copyright © 2016 Gareth Fuller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet var testButton: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func clickActivity() {
    let image = UIImage()
    let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
    self.presentViewController(controller, animated: true, completion: nil)
  }
  
  @IBAction func clickAction() {
    
    let controller = UIAlertController()
    controller.title = "Sir Jiggles rocks!"
    controller.message = "Gut zu wissen"
    
    // Dismiss the view controller after the user taps “ok”
    let okAction = UIAlertAction (title:"Rojer", style: UIAlertActionStyle.Default) {
      action in self.dismissViewControllerAnimated(true, completion: nil)
    }
    let cancelAction = UIAlertAction(title: "Tis a lie", style: .Destructive) {
      action in self.dismissViewControllerAnimated(true, completion: nil)
    }
    controller.addAction(okAction)
    controller.addAction(cancelAction)
    self.presentViewController(controller, animated: true, completion:nil)
  }
  
  @IBAction func clickImage() {
    
//    Image picker
    let nextController = UIImagePickerController()
    
    self.presentViewController(nextController, animated: true, completion: nil)
    
  }

}

