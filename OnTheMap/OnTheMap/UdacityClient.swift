//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Aaron Phillips on 5/23/16.
//  Copyright © 2016 Aaron Phillips. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient: NSObject {
    var appDelegate: AppDelegate!
    static let sharedInstance = UdacityClient()
    typealias uCompletionHandler = (data: [String: AnyObject]?, errorString: String?) -> Void
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }

    func udacityLogin(email: String, password: String, completionHandler: uCompletionHandler){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\" : {\"username\" : \"\(email)\", \"password\" : \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if let error = error {
                completionHandler(data: nil, errorString: error.localizedDescription)
                return
            }
            if let data = data {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                self.parseLogin(data: newData, completionHandler: completionHandler)
            } else{
                completionHandler(data: nil, errorString: "Login Error")
            }
        }
        task.resume()
    }
 
    func getStudentData(studentKey: String?, completionHandler: uCompletionHandler){
        if let studentKey = studentKey, url = NSURL(string: "https://www.udacity.com/api/users/" + studentKey){
            let request = NSMutableURLRequest(URL: url)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPMethod = "GET"
            
            let task = session.dataTaskWithRequest(request){
                (data, response, error) in
                
                if let error = error {
                    completionHandler(data: nil, errorString: error.localizedDescription)
                    return
                }
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                self.parseStudentData(data: newData, completionHandler: completionHandler)
            }
            task.resume()
        } else {
            completionHandler(data: nil, errorString: "Invalid Id")
        }
    }
    func parseLogin(data data: NSData, completionHandler: uCompletionHandler) {
        do{
            let parsedData =
                try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
            
            if let parsedData = parsedData {
                if let errorString = parsedData["error"] as? String {
                    completionHandler(data: nil, errorString: errorString)
                    return
                }
                if let parsedData = parsedData["account"] as? [String: AnyObject] {
                    if let hasAccount = parsedData["registered"] as? Bool{
                        if hasAccount == true {
                            if let key = parsedData["key"] as? String, registered = parsedData["registered"] as? Bool {
                                let dictionary: [String: AnyObject] = ["uniqueKey": key, "registered": registered]
                                completionHandler(data: dictionary, errorString: nil)
                            } else {
                                completionHandler(data: nil, errorString: "Unable to login")
                            }
                        } else {
                            completionHandler(data: nil, errorString: "User does not have Udacity account")
                        }
                    } else {
                        completionHandler(data: nil, errorString:"Unable to verify registration") }
                } else {
                    completionHandler(data: nil, errorString:"Account not found")
                }
            } else {
                completionHandler(data: nil, errorString: "Login Error: Unable to parse data")
            }
        } catch let error as NSError{
            completionHandler(data: nil, errorString: "Login Error: \(error.localizedDescription)")
        }
    }
    
    func parseStudentData(data data: NSData, completionHandler: uCompletionHandler){
        do{
            let parsedData =
                try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
            if let parsedData = parsedData {
                let data = parsedData["user"] as? [String: AnyObject]
                if let data = data {
                    if let firstName = (data["first_name"] as? String), lastName = (data["last_name"] as? String){
                        let dic:[String: AnyObject] =
                            ["firstName": firstName, "lastName":lastName]
                        completionHandler(data: dic, errorString: nil)
                    } else {
                        completionHandler(data: nil, errorString: "Unable to get user's name")
                    }
                } else {
                    completionHandler(data: nil, errorString: "Unable to get user data")
                }
            }else {
                completionHandler(data: nil, errorString: "Unable to parse data")
            }
        } catch let error as NSError{
            completionHandler(data: nil, errorString: error.localizedDescription)
        }
    }

}
    
