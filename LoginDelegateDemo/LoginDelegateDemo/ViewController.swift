//
//  ViewController.swift
//  LoginDelegateDemo
//
//  Created by Pasan Premaratne on 7/7/15.
//  Copyright (c) 2015 Treehouse. All rights reserved.
//

import UIKit


class ViewController: UIViewController, LoginViewControllerDelegate {
    
    
    var loggedIn: Bool = false {
        didSet {
            if loggedIn == true {
                configureView()
            }
        }
    }
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        if loggedIn == false {
            performSegueWithIdentifier("showLogin", sender: nil)
        }
    }
    
    func configureView() {
        textLabel.text = "Welcome! You are now logged in!"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didLoginSuccessfully() {
        loggedIn = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showLogin" {
            let loginVC = segue.destinationViewController as! LoginViewController
            loginVC.delegate = self
        }
    }
}

