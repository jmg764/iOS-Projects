//
//  YelpReviewsDataSource.swift
//  Plop
//
//  Created by Jonathan Glaser on 11/13/18.
//  Copyright © 2018 Jonathan Glaser. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseUI

class YelpReviewsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    private var data: [YelpReview]
    var headerNames = ["Bathroom Reviews", "Restaurant Reviews"]
    var ref: DatabaseReference!
    fileprivate var _refHandle: DatabaseHandle!
    var reviews: [DataSnapshot]!
    var imagesArray: [UIImage] = []
    var tableIndexPath: IndexPath?
    
    init(data: [YelpReview], reviews: [DataSnapshot]) {
        self.data = data
        self.reviews = Constants.reviews
        super.init()
    }
    
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return Constants.reviews.count
        } else {
            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PlopReviewCell.tableReuseIdentifier, for: indexPath) as! PlopReviewCell
            cell.imageCollectionView.delegate = self
            cell.imageCollectionView.dataSource = self
            cell.imageCollectionView.tag = indexPath.row
            cell.imageCollectionView.reloadData()

            self.tableIndexPath = indexPath
            // unpack message from firebase data snapshot
            let reviewSnapshot: DataSnapshot! = Constants.reviews[indexPath.row]
            print("Constants.reviews[indexPath.row] = ", Constants.reviews[indexPath.row])
            
            
            if let review = reviewSnapshot.value as? [String:Any] {
                // update the cell for a review with just text
                if let text = review[Constants.MessageFields.text] as? String, let name = review[Constants.MessageFields.name] as? String {
                    cell.plopReviewLabel.text = name + ": " + text
                }
                
            }
            Constants.imagesArray[(tableIndexPath?.row)!] = imagesArray
            imagesArray = []
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: YelpReviewCell.reuseIdentifier, for: indexPath) as! YelpReviewCell
            print("indexPath.section = ", indexPath.section)
            print("Constants.reviews.count = ", Constants.reviews.count)
            
            let review = object(at: indexPath)
            let viewModel = YelpReviewCellModel(review: review)
            
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerNames[section]
    }
    
    
    // MARK: Helpers
    
    func update(_ object: YelpReview, at indexPath: IndexPath) {
        data[indexPath.row] = object
    }
    
    func updateData(_ data: [YelpReview]) {
        self.data = data
    }
    
    func object(at indexPath: IndexPath) -> YelpReview {
        return data[indexPath.row]
    }
}

extension YelpReviewsDataSource: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var tableIndexPath = self.tableIndexPath
        let reviewSnapshot: DataSnapshot! = Constants.reviews[(tableIndexPath?.row)!]
        var count = 0
        if let review = reviewSnapshot.value as? [String:Any] {
            if let imageUrlArray = review[Constants.MessageFields.images] {
                count = (imageUrlArray as AnyObject).count
                print("imageUrlArray in numberOfItemsInSection = ", imageUrlArray)
            }
            
        }
        print("Count in numberOfItemsInSection = ", count)
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewImageCell", for: indexPath) as! CollectionViewCell
        var tableIndexPath = self.tableIndexPath
        let reviewSnapshot: DataSnapshot! = Constants.reviews[(tableIndexPath?.row)!]
        if let review = reviewSnapshot.value as? [String:Any] {
            print("tableIndexPath.row = ", tableIndexPath?.row)
            if let imageUrlArray = review[Constants.MessageFields.images] as? [String] {
                // download and display the image
                let imageUrl = imageUrlArray[indexPath.row]
                print("indexPath.row = ", indexPath.row)
                Storage.storage().reference(forURL: imageUrl as! String).getData(maxSize: INT64_MAX) { (data, error) in
                    guard error == nil else {
                        print("Error downloading: \(error)")
                        return
                    }
                    // display image
                    let reviewImage = UIImage.init(data: data!, scale: 50)
                    self.imagesArray.append(reviewImage!)
                    
                    
//                    Constants.imagesArray[(tableIndexPath?.row)!] = reviewImage
                    if cell == collectionView.cellForItem(at: indexPath) {
                        DispatchQueue.main.async {
                            cell.imageView.image = reviewImage
                            // Fatal error: index out of range when using cell.imageView.image = imagesArray[indexPath.row]
                            print("Review image = ", reviewImage?.images)
                            cell.setNeedsLayout()
                            Constants.reviewImage = reviewImage
                        }
                    }
                }
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Constants.selectedIndexPath = tableIndexPath
        print("Constants.imagesArray[tableIndexPath.row] = ", Constants.imagesArray[(tableIndexPath?.row)!])
    }
}

