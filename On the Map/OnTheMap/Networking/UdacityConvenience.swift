//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Jonathan on 3/30/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import Foundation

extension UdacityClient {

    //MARK: Login function to udacity
    func postSession(username: String, password: String, completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ error: NSError?) -> Void) {
        
        // The string form of httpRequestBody (below) gets converted to type Data in taskForPOSTMethod.
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        let _ = taskForPOSTMethod(method: Methods.Session, jsonBody: jsonBody) { (parsedResponse, error) in
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForSession(false, nil, NSError(domain: "completionHandlerForPOST", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError(error: "There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            guard (parsedResponse != nil) else {
                sendError(error: "No results found.")
                return
            }
            
            guard let account = parsedResponse?[JSONResponseKeys.Account] as! [String:AnyObject]? else {
                sendError(error: "No account was found.")
                return
            }
            
            guard let key = account[JSONResponseKeys.Key] as! String? else {
                sendError(error: "No key was found.")
                return
            }
            
            self.userID = key
            
            guard let session = parsedResponse?[JSONResponseKeys.Session] as! [String:AnyObject]? else {
                sendError(error: "No session was found.")
                return
            }
            
            guard let sessionID = session[JSONResponseKeys.ID] as! String? else {
                sendError(error: "No session ID was found.")
                return
            }
            
            completionHandlerForSession(true, sessionID, nil)
            
        }
        
    }
    
    func deleteSession(completionHandlerForDeleteSession: @escaping (_ success: Bool, _ sessionID: String?, _ error: NSError?) -> Void) {
        
        let _ = taskForDELETEMethod(Methods.Session)
        { (parsedResponse, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForDeleteSession(false, nil, NSError(domain: "completionHandlerForDELETE", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError(error: "There was an error with your request: \(String(describing: error))")
                return
            }
            
            guard (parsedResponse != nil) else {
                sendError(error: "No results were found.")
                return
            }
            
            guard let session = parsedResponse?[JSONResponseKeys.Session] as! [String:AnyObject]? else {
                sendError(error: "No session was found.")
                return
            }
            
            guard let sessionID = session[JSONResponseKeys.ID] as! String? else {
                sendError(error: "No session ID was found.")
                return
            }
            
            // Only if there is a session ID (success = true) can we delete a session.
            completionHandlerForDeleteSession(true, sessionID, nil)
        }
    }

    func getUserData(userID: String?, completionHandlerForUserData: @escaping (_ success: Bool, _ firstName: String?, _ lastName: String?, _ error: NSError?) -> Void) {
        let _ = taskForGETMethod(method: Methods.User + self.userID!) { (parsedResponse, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForUserData(false, nil, nil, NSError(domain: "completionHandlerForGET", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError(error: "There was an error with your request: \(error)")
                return
            }
            
            guard (parsedResponse != nil) else {
                sendError(error: "No results were found.")
                return
            }
            
            guard let user = parsedResponse?[JSONResponseKeys.User] as! [String:AnyObject]? else {
                sendError(error: "No user was found.")
                return
            }
            
            guard let firstName = user[JSONResponseKeys.FirstName] as! String? else {
                sendError(error: "No first name was found.")
                return
            }
            
            guard let lastName = user[JSONResponseKeys.LastName] as! String? else {
                sendError(error: "No last name was found.")
                return
            }
            
            completionHandlerForUserData(true, firstName, lastName, nil)
        }
        
    /*
    func getUserID(_ completionHandlerForGetUserID: @escaping (_ success: Bool,_ userID: String?, _ errorString: String?) -> Void) {
        
        let _ = taskForPOSTMethod(method: <#T##String#>, jsonBody: <#T##String#>, completionHandlerForPOST: <#T##(AnyObject?, NSError?) -> Void#>)() { (result, error) in
            
            if let error = error {
                print(error)
                completionHandlerForGetUserID(false, nil, "Login unsuccessful")
            } else {
                if let account = result?["account"] as? [String:AnyObject] {
                    if let userId = account["key"] as? String {
                        print ("User ID: \(userId)")
                        LoginData.uniqueKey = userId
                        completionHandlerForGetUserID(true, userId, nil)
                    } else {
                        print ("User ID not found")
                        completionHandlerForGetUserID(false, nil, "Login unsuccessful")
                    }
                } else {
                    print("Account not found")
                    completionHandlerForGetUserID(false, nil, "Login unsuccessful")
                }
            }
        }
    }

    
    func authenticateWithViewController(_ hostViewController: UIViewController, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        getUserID() { (success, userID, errorString) in
            if success {
                if let userID = userID {
                    self.getUserData(userID: userID) { (success, firstName, lastName, error) in
                        completionHandlerForAuth(success, errorString)
                    }
                } else {
                    completionHandlerForAuth(success, "Authentication unsuccessful")
                }
            }
            
        }
    }
 */
    
}
}



    
    


