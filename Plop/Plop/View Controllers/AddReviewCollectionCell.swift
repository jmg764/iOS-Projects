//
//  AddReviewCollectionCell.swift
//  Plop
//
//  Created by Jonathan Glaser on 12/31/18.
//  Copyright © 2018 Jonathan Glaser. All rights reserved.
//

import Foundation
import UIKit

class AddReviewCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage! {
        didSet{
            self.imageView.image = image
            self.setNeedsLayout()
        }
    }
    
}
