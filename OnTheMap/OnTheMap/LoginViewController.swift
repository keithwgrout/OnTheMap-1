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
        login()
    }
    
    func login(){
        self.loginButton.enabled = false
        if let udacityClient = udacityClient {
            udacityClient.udacityLogin(userIDTextField.text!, password: passwordTextField.text!){
                data, error in
                if data != nil{
                    if let _ = self.appDelegate{
                        if self.appDelegate != nil{
                            self.appDelegate?.currentStudent = Student(dictionary: data)
                            self.getPublicData()
                        }else{
                            self.displayError("ERROR: Login Failed 1")}
                    }else{
                        self.displayError("ERROR: Login Failed 2")}
                }else{
                    self.displayError("ERROR: Login Failed 3")}
            }
        }else{
            self.displayError("ERROR: Login Failed 4")
        }
    }
    
    func getPublicData(){
        if let appDelegate = appDelegate{
            if let key = appDelegate.currentStudent?.uniqueKey{
                udacityClient?.getStudentData(key){
                    data, error in
                    if let data = data{
                        dispatch_async(dispatch_get_main_queue()){
                            self.appDelegate!.currentStudent!.firstName = data["firstName"] as? String
                            self.appDelegate!.currentStudent!.lastName = data["lastName"] as? String
                            self.loginButton.enabled = true
                            self.goToMap()
                    }
                }else{
                    self.displayError("ERROR")}
            }
        }else{
            self.displayError("ERROR")}
    }else{
        self.displayError("ERROR")}
    }
    
    func goToMap(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabController = storyboard.instantiateViewControllerWithIdentifier("TabView") as? UITabBarController
        if let tabController = tabController{
            presentViewController(tabController, animated: true, completion: nil)
        }
    }
    
    func displayError(errorMessage: String) {
        dispatch_async(dispatch_get_main_queue()){
            self.loginButton.enabled = true
            self.debugLabelText.text = errorMessage
            }
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

    
    