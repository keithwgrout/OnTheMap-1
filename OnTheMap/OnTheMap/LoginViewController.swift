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
        
        // get the app delegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }

    @IBAction func loginButtonPressed(sender: AnyObject) {
        print("Login Button Pressed")
        
        func getSessionID(){
            // 1. Set the parameters
            let methodParameters: [String: String!] = [
                Constants.user.Username: userIDTextField.text,
                Constants.user.password: passwordTextField.text
            ]
            print("method parameters set")
            
            
            // 2/3. Build the URL, Configure the request
            let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
            
            // 4. Make the request
            let task = appDelegate.sharedSession.dataTaskWithRequest(request) { (data, response, error) in
                
                // error
                func displayError(error: String, debugLabelText: String? = nil) {
                    print(error)
                    performUIUpdatesOnMain {
                        self.debugLabelText.text = "Login Failed (Login Step)"
                    }
                }
                
                // GUARD
                guard (error == nil) else {
                    displayError("There was an error with your request: \(error)")
                    return
                }
                
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                    displayError("Your request returned a status code other than 2xx!")
                    return
                }
                
                guard let data = data else {
                    displayError("No data was returned by the request")
                    return
                }
                
                // 5. Parse the data
                let parsedResult: AnyObject!
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                } catch {
                    displayError("Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                guard let sessionID = parsedResult[Constants.sessionResponseKeys.id] as? String else {
                    displayError("Cannod find key '\(Constants.sessionResponseKeys.id)' in \(parsedResult)")
                    return
                }
                
                
                // 6. Use the data
                self.appDelegate.sessionID = sessionID
                print (sessionID)
                
            }
            // 7. Start the request
            task.resume()
            
        }
        

    }
    }

