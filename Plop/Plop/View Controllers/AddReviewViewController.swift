//
//  AddReviewViewController.swift
//  Plop
//
//  Created by Jonathan Glaser on 11/23/18.
//  Copyright © 2018 Jonathan Glaser. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseUI


class AddReviewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var msglength: NSNumber = 1000
    var keyboardOnScreen = false
    var ref: DatabaseReference!
    var storageRef: StorageReference!
    var displayName = Constants.displayName
    var imageUrlArray: [String] = []
    var autoID: String = ""
    var selectedImages: [UIImage] = []
    
    
    @IBOutlet weak var textField: UITextView!
    @IBAction func postReviewButton(_ sender: Any) {
        postReview()
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        UserDefaults.standard.set(nil, forKey: "Review")
        let alert = UIAlertController(title: "Success", message: "Your review has been successfully submitted", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let controller = self.storyboard!.instantiateInitialViewController()
            self.present(controller!, animated: false, completion: nil)
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    func createPhotoUrl(photoData: Data) {
        // build a path using the user's ID and a timestamp
        let imagePath = "plop_photos/" + (Auth.auth().currentUser?.uid)! + "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        // set content type to "image/jpeg" in firebase storage meta data
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        // create a child node at imagePath with photoData and metadata
        storageRef!.child(imagePath).putData(photoData, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("error uploading: \(error)")
                return
            }
            // use sendMessage to add imageURL to database
            var imageUrl = self.storageRef!.child((metadata?.path)!).description
            self.imageUrlArray.append(imageUrl)
            print(self.imageUrlArray)
        }
        
    }
    
    override func viewDidLoad() {
        configureDatabase()
        configureStorage()
        textField.delegate = self as? UITextViewDelegate
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let photoAlbumButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.camera, target: self, action: #selector(photoBarButton))
        toolBar.setItems([photoAlbumButton], animated: true)
        textField.inputAccessoryView = toolBar
        
        if UserDefaults.standard.value(forKey: "Review") == nil {
            textField.text = "Write your review here"
        } else {
            textField.text = UserDefaults.standard.value(forKey: "Review") as! String
        }
        
        activityIndicator.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        self.collectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.set(textField.text, forKey: "Review")
    }
    
    
    @objc func photoBarButton() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func postReview() {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                self.activityIndicator.startAnimating()
                self.activityIndicator.isHidden = false
            } else {
                let alert = UIAlertController(title: "Error", message: "Unable to connect to database", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
        
        var childOfRestaurantReviews = self.ref.child("\(Constants.businessID!)").childByAutoId()
        self.autoID = childOfRestaurantReviews.key!

        // Set name
        var nameData = [Constants.MessageFields.name: self.displayName]
        childOfRestaurantReviews.setValue(nameData)
        
        // Set images
        var imagesData = childOfRestaurantReviews.child(Constants.MessageFields.images)
        imagesData.setValue(imageUrlArray)
        
        // Set text
        if !textField.text!.isEmpty {
            var textData = childOfRestaurantReviews.child(Constants.MessageFields.text)
            textData.setValue(textField.text)
        }
        
        var cleanlinessRatingsData = childOfRestaurantReviews.child("cleanliness rating")
        cleanlinessRatingsData.setValue(Constants.ratings.cleanlinessRating)
        var privacyRatingsData = childOfRestaurantReviews.child("privacy rating")
        privacyRatingsData.setValue(Constants.ratings.privacyRating)
        var essentialsRatingsData = childOfRestaurantReviews.child("essentials rating")
        essentialsRatingsData.setValue(Constants.ratings.essentialsRating)
        var smellRatingsData = childOfRestaurantReviews.child("smell rating")
        smellRatingsData.setValue(Constants.ratings.smellRating)
        var aestheticRatingsData = childOfRestaurantReviews.child("aesthetic rating")
        aestheticRatingsData.setValue(Constants.ratings.aestheticRating)
    }
    
    func configureDatabase() {
        // TODO: configure database to sync messages
        ref = Database.database().reference()
    }
    
    func configureStorage() {
        storageRef = Storage.storage().reference()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("selectedImages.count = ", selectedImages.count)
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewImageCell", for: indexPath) as! AddReviewCollectionCell
        var image = selectedImages[indexPath.item]
        cell.imageView.image = image
        
        return cell
    }
}

// MARK: - AddReviewViewController: UITextFieldDelegate

extension AddReviewViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // set the maximum length of the message
        guard let text = textField.text else { return true }
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= msglength.intValue
    
    }
    
    
    // MARK: Show/Hide Keyboard
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            self.view.frame.origin.y -= self.keyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            self.view.frame.origin.y += self.keyboardHeight(notification)
        }
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
        //dismissKeyboardRecognizer.isEnabled = true
        //scrollToBottomMessage()
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        //dismissKeyboardRecognizer.isEnabled = false
        keyboardOnScreen = false
    }
    
    func keyboardHeight(_ notification: Notification) -> CGFloat {
        return ((notification as NSNotification).userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.height
    }

}


// MARK: - FCViewController: UIImagePickerControllerDelegate
extension AddReviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func addPhotoButton(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey:Any]) {
        // constant to hold the information about the photo
        if let photo = info[.originalImage] as? UIImage, let photoData = photo.jpegData(compressionQuality: 0.8) {
            selectedImages.append(photo)
            print("selectedImages = ", selectedImages)
//            print("selectedImages.count = ", selectedImages.count)
            // call function to upload photo message
            createPhotoUrl(photoData: photoData)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - FCViewController (Notifications)

extension AddReviewViewController {
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func subscribeToNotification(_ name: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    class func sharedInstance() -> AddReviewViewController {
        struct Singleton {
            static var sharedInstance = AddReviewViewController()
        }
        return Singleton.sharedInstance
    }
}

