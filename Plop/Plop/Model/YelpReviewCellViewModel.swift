//
//  YelpReviewCellModel.swift
//  Plop
//
//  Created by Jonathan Glaser on 11/13/18.
//  Copyright © 2018 Jonathan Glaser. All rights reserved.
//

import Foundation
import UIKit

struct YelpReviewCellModel {
    let review: String
    let userImage: UIImage
}

extension YelpReviewCellModel {
    init(review: YelpReview) {
        self.review = review.text
        self.userImage = review.user.image ?? #imageLiteral(resourceName: "Screen Shot 2018-11-10 at 12.02.58 AM")
    }
}
