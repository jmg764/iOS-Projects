//
//  AddPinViewController.swift
//  OnTheMap
//
//  Created by Jonathan Glaser on 4/1/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddPinViewController: UIViewController {
    
    var firstName: String?
    var lastName: String?
    
    var geocoder = CLGeocoder()
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func findLocationPressed(_ sender: Any) {
        
        checkMapString(mapString: self.locationTextField.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func checkMapString(mapString: String) {
        geocoder.geocodeAddressString(mapString) { (placemarks, error) in
            
            // Show alert if mapString is not a valid location
            if error != nil {
                AlertView.showErrorAlert(controller: self, message: "Please enter a valid location")
            } else {
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddLinkViewController") as! AddLinkViewController
                
                // Pass first name and last name data to the next controller
                controller.firstName = self.firstName
                controller.lastName = self.lastName
                
                // Pass the entered city data to the next controller
                controller.mapString = self.locationTextField.text
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
}
