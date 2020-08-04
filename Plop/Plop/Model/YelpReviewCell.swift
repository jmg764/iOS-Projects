//
//  YelpReviewCell.swift
//  Plop
//
//  Created by Jonathan Glaser on 11/13/18.
//  Copyright © 2018 Jonathan Glaser. All rights reserved.
//

import Foundation
import UIKit

class YelpReviewCell: UITableViewCell {
    
    static let reuseIdentifier = "YelpReviewCell"
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with viewModel: YelpReviewCellModel) {
        reviewLabel.text = viewModel.review
        userImageView.image = viewModel.userImage
    }
    
}
