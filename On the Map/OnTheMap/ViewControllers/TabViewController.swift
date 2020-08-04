//
//  TabViewController.swift
//  OnTheMap
//
//  Created by Jonathan Glaser on 3/30/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import Foundation

class TabViewController: UITabBarController {
    
    var firstName: String?
    var lastName: String?
    
    @IBAction func logoutPressed(_ sender: Any) {
        
        UdacityClient.sharedInstance().deleteSession() { (success, sessionID, error) in
            
            performUIUpdatesOnMain {
                
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    AlertView.showErrorAlert(controller: self, message: "Logout failed.")
                }
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPinPressed(_ sender: Any) {
        
        ParseClient.sharedInstance().getSingleStudentLocation() { (studentLocation, error) in
            
            performUIUpdatesOnMain {
                
                if studentLocation != nil {
                    AlertView.showOverwriteAlert(controller: self, message: AlertView.Messages.overwritePin)
                    self.openAddPinVC()
                } else {
                    self.openAddPinVC()
                }
            }
        }
    }
    
    @IBAction func refreshPinLocations(_ sender: UIBarButtonItem) {
        ParseClient.sharedInstance().getStudentLocations(completionHandler: {(success, studentInfoArray, error) in
            if success {
                performUIUpdatesOnMain {
                    // Confirm the update with AlertView
                    AlertView.showErrorAlert(controller: self, message: "Database updated")
                    
                    // Update the table ('list') view
                    //ListViewController.tableView.reloadData()
                    
                    // TODO: Refresh map view
                }
            } else {
                performUIUpdatesOnMain {
                    AlertView.showErrorAlert(controller: self, message: "Error")
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //loadStudentLocations()
        //getUserData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openAddPinVC() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "AddPinViewController") as! AddPinViewController
        controller.firstName = self.firstName
        controller.lastName = self.lastName
        present(controller, animated: true, completion: nil)
    }
}

