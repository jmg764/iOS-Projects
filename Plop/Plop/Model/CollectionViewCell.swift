//
//  CollectionViewCell.swift
//  Plop
//
//  Created by Jonathan Glaser on 11/27/18.
//  Copyright © 2018 Jonathan Glaser. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseUI

class CollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var imageView: UIImageView!
    
    
    var image: UIImage! {
        didSet{
            self.imageView.image = image
            self.setNeedsLayout()
        }
    }
    
    
}
