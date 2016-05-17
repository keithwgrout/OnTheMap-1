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
        createSession()
        print("Login Button Pressed")
    }
    
    private func createSession(){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\" : {\"username\" : \"\(self.userIDTextField.text!)\", \"password\" : \"\(self.passwordTextField.text!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        
        let task = appDelegate.sharedSession.dataTaskWithRequest(request) { (data, response, error) in
        
            if error != nil {
                print("Error in task")
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as? NSDictionary
            } catch {
                print("Error")
                return
                
            }
            print (parsedResult)
            
        }
        // 7. Start the request
        task.resume()
        
    }


    }

