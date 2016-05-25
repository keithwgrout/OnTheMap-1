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
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        udacityClient?.login(userIDTextField.text!, password: passwordTextField.text!)
    }
}

    
    