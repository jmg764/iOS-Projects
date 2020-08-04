//
//  PlopReviewCell.swift
//  Plop
//
//  Created by Jonathan Glaser on 11/24/18.
//  Copyright © 2018 Jonathan Glaser. All rights reserved.
//

import Foundation
import UIKit

class PlopReviewCell: UITableViewCell {
    
    static let tableReuseIdentifier = "PlopReviewCell"
    static let collectionReuseIdentifier = "ReviewImageCell"
    
    @IBOutlet weak var plopReviewLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {

        imageCollectionView.delegate = dataSourceDelegate
        imageCollectionView.dataSource = dataSourceDelegate
        imageCollectionView.tag = row
        imageCollectionView.reloadData()
    }
    
}
