//
//  ViewController.swift
//  OnTheMap
//
//  Created by Aaron Phillips on 5/13/16.
//  Copyright © 2016 Aaron Phillips. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugLabelText: UILabel!
    
    var appDelegate: AppDelegate!
    var keyboardOnScreen = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }


    @IBAction func loginButtonPressed(sender: AnyObject) {
        self.appDelegate.userID = userIDTextField.text
        self.appDelegate.password = passwordTextField.text
        self.appDelegate.debugLabel = debugLabelText.text
        appDelegate.udacityClient?.login()
    }
    
    }