//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Jonathan Glaser on 3/15/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate{

    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var udacityUsername: UITextView!
    @IBOutlet weak var udacityPassword: UITextView!
    @IBAction func udacityLoginPressed(_ sender: Any) {
        if (self.udacityUsername.text == "" || self.udacityPassword.text == "" ) {
            AlertView.showErrorAlert(controller: self, message: "Your email or password cannot be blank.")
        } else {
            UdacityClient.LoginData.username = udacityUsername.text!
            UdacityClient.LoginData.password = udacityPassword.text!
            
            UdacityClient.sharedInstance().postSession(username: UdacityClient.LoginData.username, password: UdacityClient.LoginData.password) { (success, sessionID, errorString)  in
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                    } else {
                        performUIUpdatesOnMain {
                            print(errorString as Any)
                        }
                    }
                }
                
            }
        }
    }
    
    @IBAction func signUpPressed(_ sender: AnyObject) {
        if let signUpURL = URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated") {
            UIApplication.shared.open(signUpURL)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.delegate = self
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        if let token = FBSDKAccessToken.current() {
            fetchProfile()
        // Obtain all constraints for the button:
        let layoutConstraintsArr = loginButton.constraints
        // Iterate over array and test constraints until we find the correct one:
        for lc in layoutConstraintsArr { // or attribute is NSLayoutAttributeHeight etc.
            if ( lc.constant == 28 ){
                // Then disable it...
                lc.isActive = false
                break
                }
            }
        }
        subscribeToKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FBSDKAccessToken.current() != nil{
            let protectedPage = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
            let protectedPageNav = UINavigationController(rootViewController: protectedPage)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = protectedPageNav
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("User Logged In")
        if ((error) != nil)
        {
            print(error.localizedDescription)
            return
        }
        else {
            if let userToken = result.token {
                let token:FBSDKAccessToken = result.token
                let protectedPage = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
                let protectedPageNav = UINavigationController(rootViewController: protectedPage)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = protectedPageNav
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func fetchProfile() {
        print("fetch profile")
        let parameters = ["fields":"email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start{(connection, result, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            guard let resultNew = result as? [String:Any] else {
                return
            }
            let email = resultNew["email"] as! String
        }
    }

    private func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    //Make keyboard disappear upon pressing return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if udacityPassword.isFirstResponder{
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}

