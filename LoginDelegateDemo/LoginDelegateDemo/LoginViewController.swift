//
//  LoginViewController.swift
//  LoginDelegateDemo
//
//  Created by Pasan Premaratne on 7/7/15.
//  Copyright (c) 2015 Treehouse. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate {
    func didLoginSuccessfully()
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var delegate: LoginViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonPressed(sender: AnyObject) {
        if usernameField.text == "gareth" && passwordField.text == "test1234" {
            resignFirstResponder()
            delegate?.didLoginSuccessfully()
        } else {
            let alertController = UIAlertController(title: "Error!", message: "The username and password combination failed.", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            })
            alertController.addAction(ok)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let length = (textField.text?.characters.count)! - range.length + string.characters.count
        if length > 0 {
            submitButton.enabled = true
        } else {
            submitButton.enabled = false
        }
        return true
    }
}
