//
//  ViewController.swift
//  OnTheMap
//
//  Created by Aaron Phillips on 5/13/16.
//  Copyright © 2016 Aaron Phillips. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugLabelText: UILabel!
    
    var appDelegate: AppDelegate?
    var udacityClient: UdacityClient?
    var keyboardOnScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIDTextField.delegate = self
        passwordTextField.delegate = self
        udacityClient = UdacityClient.sharedInstance
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        subscribeToKeyboardNotifications()

    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        udacityClient?.login(userIDTextField.text!, password: passwordTextField.text!)
    }
    
    // Subscribe to keyboard notifications
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:))    , name: UIKeyboardWillHideNotification, object: nil)
    }
    // Unsubscribe from keybaord notitfications
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    //Show keyboard for bottom text
    func keyboardWillShow(notification: NSNotification) {
            view.frame.origin.y = getKeyboardHeight(notification) * -0.5
    }
    
    // Hide keyboard after editing bottom text
    func keyboardWillHide(notification: NSNotification) {
            view.frame.origin.y = 0
    }
    
    // Get keyboard height
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    // Return button hides keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
}

    
    