//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Jonathan Glaser on 3/30/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import Foundation

class ListViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Student")
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInfo.studentLocationList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Student")!
        let student = StudentInfo.studentLocationList[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = "student.firstName"
        cell.detailTextLabel?.text = student.mediaURL
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let student = StudentInfo.studentLocationList[indexPath.row]
        
        if let studentURL = URL(string: student.mediaURL!) {
            
            if UIApplication.shared.canOpenURL(studentURL) {
                UIApplication.shared.open(studentURL)
            } else {
                self.showErrorAlert(messageText: "Not a valid URL.")
            }
        }
    }
}

private extension ListViewController {
    
    func showErrorAlert(messageText: String) {
        let alert = UIAlertController(title: "Alert", message: messageText, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

