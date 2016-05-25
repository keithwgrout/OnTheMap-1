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
    static let sharedInstance = UdacityClient()
    static let publicDataURL: String = "https://www.udacity.com/api/users/"
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }

    func login(email: String, password: String){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\" : {\"username\" : \"\(email)\", \"password\" : \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            func displayError(error: String, debugLabelText: String? = nil) {
                print (error)
                performUIUpdatesOnMain {
                    self.appDelegate.loginView.debugLabelText.text = "Login Failed"
                }
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Could not parse data as JSON")
                return
            }
            if let sessionDictionary = parsedResult[Constants.keys.session] as? [String: AnyObject]{
                guard let sessionID = sessionDictionary[Constants.session.id] else {
                    displayError("Could not find key \(Constants.session.id) in \(parsedResult)")
                    return
                }
                print (sessionID)
            }
        }
        task.resume()
    }
    
}