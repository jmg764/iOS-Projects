//  MemeEditorViewController.swift
//  MemeMe1
//
//  Created by Jonathan Glaser on 2/10/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var toolBarTop: UIToolbar!
    
    @IBOutlet weak var toolBarBottom: UIToolbar!
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        presentImagePickerWith(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        presentImagePickerWith(sourceType: .camera)
    }
    
    @IBAction func sharePressed(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.completionWithItemsHandler = { activity, completed, items, error -> Void in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let memeTextAttributes: [String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue : UIColor.white,
            NSAttributedStringKey.font.rawValue : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue : -3
        ]
        func configureText(textField: UITextField, withText text: String) {
            textField.text = text
            textField.defaultTextAttributes = memeTextAttributes
            textField.textAlignment = NSTextAlignment.center
            textField.delegate = self
        }
        
        configureText(textField: topTextField, withText: "TOP")
        configureText(textField: bottomTextField, withText: "BOTTOM")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        shareButton.isEnabled = (imagePickerView.image != nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder {
            self.view.frame.origin.y -= getKeyboardHeight(notification as Notification)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder {
            self.view.frame.origin.y += getKeyboardHeight(notification as Notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }

    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func save() {
        // Create the meme
        let meme = MemeStruct.Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: self.generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }

    func navAndToolBarHide(_ hide: Bool){
        self.navigationController?.setNavigationBarHidden(hide, animated: hide)
        toolBarTop.isHidden = hide
        toolBarBottom.isHidden = hide
        albumButton.accessibilityElementsHidden = hide
        cameraButton.accessibilityElementsHidden = hide
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        navAndToolBarHide(true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        navAndToolBarHide(false)
        
        return memedImage
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    
    
    
    
}
