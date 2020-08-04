//
//  AddLinkViewController.swift
//  OnTheMap
//
//  Created by Jonathan Glaser on 4/1/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLinkViewController: UIViewController {
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    
    var objectID: String?
    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidesWhenStopped = true;
        showPinOnMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getObjectID()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPinOnMap() {
        
        geocoder.geocodeAddressString(mapString!) { (placemarks, error) in
            
            // Must unwrap the placemark. Placemarks is an array of potential locations for the entered name. The first property retrieves the first result.
            if let placemark = placemarks?.first  {
                
                // Get latitude and longitude values from placemark
                self.latitude = placemark.location?.coordinate.latitude
                self.longitude = placemark.location?.coordinate.longitude
                
                // Convert CLPlacemark to MKPlacemark so that we can add it to mapView.
                let mapKitPlacemark = MKPlacemark(placemark: placemark)
                self.mapView.addAnnotation(mapKitPlacemark)
                
                // Zoom map to the correct region for showing the pin
                self.mapView.centerCoordinate = (placemark.location?.coordinate)!
                // Instantiate an MKCoordinateSpanMake to pass into MKCoordinateRegion
                let coordinateSpan = MKCoordinateSpanMake(80,80)
                // Instantiate an MKCoordinateRegion to pass into setRegion.
                let coordinateRegion = MKCoordinateRegion(center: (placemark.location?.coordinate)!, span: coordinateSpan)
                self.mapView.setRegion(coordinateRegion, animated: true)
                
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        
        // Unwrap the values so they're not preceded with "Optional" in the request body.
        if let uniqueKeyUnwrapped = UdacityClient.sharedInstance().userID,
            let firstNameUnwrapped = self.firstName,
            let lastNameUnwrapped = self.lastName,
            let mapStringUnwrapped = self.mapString,
            let mediaURLUnwrapped = self.linkTextField.text,
            let latitudeUnwrapped = self.latitude,
            let longitudeUnwrapped = self.longitude {
            
            // This string-formatted dictionary contains the contents required for the http request body.
            let loggedInUser: String = "{\"uniqueKey\": \"\(uniqueKeyUnwrapped)\", \"firstName\": \"\(firstNameUnwrapped)\", \"lastName\": \"\(lastNameUnwrapped)\",\"mapString\": \"\(mapStringUnwrapped)\", \"mediaURL\": \"\(mediaURLUnwrapped)\",\"latitude\": \(latitudeUnwrapped), \"longitude\": \(longitudeUnwrapped)}"
            
            // If objectID exists, use Parse's PUT method to update student location with objectID in URL. Pass in loggedInUser dictionary.
            // If objectID doesn't exist, use Parse's POST method to create a new student location. Pass in loggedInUser dictionary.
            if self.objectID != nil {
                
                ParseClient.sharedInstance().putStudentLocation(studentDictionary: loggedInUser) { (updatedAt, error) in
                    
                    performUIUpdatesOnMain {
                        if error == nil {
                            
                            // Dismiss the modal view and go back to TabViewController.
                            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                        } else {
                            AlertView.showErrorAlert(controller: self, message: "\(error?.localizedDescription)")
                        }
                    }
                }
                
            } else {
                
                ParseClient.sharedInstance().postStudentLocation(studentDictionary: loggedInUser) { (objectID, error) in
                    
                    performUIUpdatesOnMain {
                        if error == nil {
                            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                        } else {
                            AlertView.showErrorAlert(controller: self, message: "\(error?.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    func getObjectID () {
        
        ParseClient.sharedInstance().getSingleStudentLocation() { (studentLocation, error) in
            
            // If there's an error, just return out of this function?
            if (error != nil) {
                return
            }
            
            // Access the first (and only) dictionary in the array.
            let dictionary = studentLocation![0]
            
            // Unwrap the objectID
            guard let objectID = dictionary[ParseClient.JSONResponseKeys.ObjectId] as? String else {
                print("objectID not found")
                return
            }
            
            self.objectID = objectID
        }
    }
}
