//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Jonathan Glaser on 3/24/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import Foundation

extension ParseClient {
    
    func getStudentLocations(completionHandler: @escaping (_ success: Bool, _ studentInfoArray: [StudentInfo]?, _ error: NSError?) -> Void) {
        
        let parameters = "?\(ParameterKeys.Limit)=100&\(ParameterKeys.Skip)=200&\(ParameterKeys.Order)=-updatedAt"
        let method = ParseClient.Methods.StudentLocation
        
        taskForGETMethod(method, parameters) { JSONResult, error in
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandler(false, nil, NSError(domain: "completionHandlerForGET", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError(error: "There was an error with your request: \(error)")
                return
            }
            
            guard (JSONResult != nil) else {
                sendError(error: "No results were found.")
                return
            }
            
            // drill down to the array of student location dictionaries
            guard let studentLocations = JSONResult?[JSONResponseKeys.Results] as? [[String:AnyObject]]? else {
                sendError(error: "No results were found.")
                return
            }
            /*
            StudentInfo.studentLocationList = StudentInfo.locationsFromResults(results: studentLocations!)
            
            completionHandler(true, StudentInfo.studentLocationList, nil)
            */
            var studentInfoArray: [StudentInfo] = []
            for student in studentLocations! {
                let studentDictionary = StudentInfo(dictionary: student)
                studentInfoArray.append(studentDictionary)
            }
            StudentInfo.studentLocationList = studentInfoArray
            
            completionHandler(true, StudentInfo.studentLocationList, nil)
        }
    }
    
     func getSingleStudentLocation(completionHandlerForStudentLocation: @escaping (_ studentLocation: [[String:AnyObject]]?, _ error: NSError?) -> Void) {
        
        let parameters = "\(ParameterKeys.Where)=%7B%22\(JSONResponseKeys.UniqueKey)%22%3A%22\(UdacityClient.sharedInstance().userID!)%22%7D"
        let methods = ParseClient.Methods.StudentLocation
    
        let _ = taskForGETMethod(methods, parameters) { (parsedResponse, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForStudentLocation(nil, NSError(domain: "completionHandlerForGET", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError(error: "There was an error with your request: \(error)")
                return
            }
            
            guard (parsedResponse != nil) else {
                sendError(error: "No results were found.")
                return
            }
            
            guard let studentLocation = parsedResponse?[JSONResponseKeys.Results] as? [[String: AnyObject]] else {
                sendError(error: "No results were found.")
                return
            }
            
            completionHandlerForStudentLocation(studentLocation, nil)
        }
    }
    
    func postStudentLocation(studentDictionary: String, completionHandlerForPostLocation: @escaping (_ objectID: String?, _ error: NSError?) -> Void) {
        
        let methods = ParseClient.Methods.StudentLocation
        
        let _ = taskForPOSTMethod(methods, jsonBody: studentDictionary) { (parsedResponse, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPostLocation(nil, NSError(domain: "completionHandlerForPOST", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError(error: "There was an error with your request: \(error)")
                return
            }
            
            guard (parsedResponse != nil) else {
                sendError(error: "No results were found.")
                return
            }
            
            guard let objectID = parsedResponse?[JSONResponseKeys.ObjectId] as! String? else {
                sendError(error: "No results were found.")
                return
            }
            
            JSONResponseKeys.ObjectId = objectID
            
            completionHandlerForPostLocation(objectID, nil)
        }
    }
    
    func putStudentLocation(studentDictionary: String, completionHandlerForPutLocation: @escaping (_ updatedAt: String?, _ error: NSError?) -> Void) {
        
        let methods = ParseClient.Methods.StudentLocation
        
        let _ = taskForPUTMethod(methods, parameters: JSONResponseKeys.ObjectId, jsonBody: studentDictionary) { (parsedResponse, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPutLocation(nil, NSError(domain: "completionHandlerForPUT", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError(error: "There was an error with your request: \(error)")
                return
            }
            
            guard (parsedResponse != nil) else {
                sendError(error: "No results were found.")
                return
            }
            
            guard let updatedAt = parsedResponse?[JSONResponseKeys.UpdatedAt] as! String? else {
                sendError(error: "No results were found.")
                return
            }
            
            completionHandlerForPutLocation(updatedAt, nil)
        }
    }
}

