//
//  MemeCollectionViewController.swift
//  MemeMe1
//
//  Created by Jonathan Glaser on 2/21/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [MemeStruct.Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Saved Memes"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        let space:CGFloat = 3.0
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
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
        textField.delegate = self as? UITextFieldDelegate
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomMemeCell", for: indexPath) as! CustomMemeCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        configureText(textField: cell.memeTopText, withText: meme.topText)
        configureText(textField: cell.memeBottomText, withText: meme.bottomText)
        cell.memeImageView?.image = meme.originalImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        //Populate view controller with data from the selected item
        detailController.memeDetail = memes[(indexPath as NSIndexPath).row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        collectionView?.reloadData()
    }
}
