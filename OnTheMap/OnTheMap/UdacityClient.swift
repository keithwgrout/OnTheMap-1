//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Aaron Phillips on 5/23/16.
//  Copyright © 2016 Aaron Phillips. All rights reserved.
//

import UIKit

class UdacityClient: NSObject {
    var appDelegate: AppDelegate!
    
    /*func login(){
        
        print ("Login Button Pressed")
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\" : {\"username\" : \"\(appDelegate.loginView.userIDTextField.text!)\", \"password\" : \"\(appDelegate.loginView.passwordTextField.text!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = appDelegate.sharedSession.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            // Error display function
            func displayError(error: String, debugLabelText: String? = nil) {
                print (error)
                performUIUpdatesOnMain {
                    self.appDelegate.loginView.debugLabelText.text = "Login Failed"
                }
            }
            
            // GUARD: Is there an error?
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return
            }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx.")
                return
            }
            guard let data = data else {
                displayError("No data was returned by the request.")
                return
            }
            
            // Ignore first 5 characters of data
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            // Parse the JSON data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Could not parse data as JSON")
                return
            }
            
            // Grab the session ID from parsedResult
            if let sessionDictionary = parsedResult[Constants.keys.session] as? [String: AnyObject]{
                guard let sessionID = sessionDictionary[Constants.session.id] else {
                    displayError("Could not find key \(Constants.session.id) in \(parsedResult)")
                    return
                }
                print (sessionID)
                
            }
        })
        
        // 7. Start the request
        task.resume()
    }
*/
    }