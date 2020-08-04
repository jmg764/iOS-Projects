//
//  AlertView.swift
//  OnTheMap
//
//  Created by Jonathan Glaser on 4/1/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

class AlertView {
    
    class func showErrorAlert(controller: UIViewController, message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        performUIUpdatesOnMain {
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    class func showOverwriteAlert(controller: UIViewController, message: String) {
        let alert = UIAlertController(title: "Overwrite", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
    }
}

extension AlertView {
    
    struct Messages {
        static let usernameOrPasswordFieldEmpty = "Please enter your email and password."
        static let emptyError = "Unable to get student data."
        static let locationFieldEmpty = "Please enter your location."
        static let websiteFieldEmpty = "Please enter a website url."
        static let emptyPlacemark = "Placemark not found."
        static let logoutFailed = "Unable to log out."
        static let locationAlreadyPosted = "You have already posted a student location. Would you like to overwrite it?"
        static let invalidURL = "Invalid URL."
        static let overwritePin = "Do you want to overwrite your existing location?"
    }
}
