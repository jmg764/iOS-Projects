//
//  StarRatingViewController.swift
//  Plop
//
//  Created by Jonathan Glaser on 12/10/18.
//  Copyright © 2018 Jonathan Glaser. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseUI

class StarRatingViewController: UIViewController {
    
    @IBOutlet weak var cleanlinessRating: CosmosView!
    @IBOutlet weak var privacyRating: CosmosView!
    @IBOutlet weak var essentialsRating: CosmosView!
    @IBOutlet weak var smellRating: CosmosView!
    @IBOutlet weak var aestheticRating: CosmosView!
    
    @IBAction func doneButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cleanlinessRating.didFinishTouchingCosmos = {rating in
            Constants.ratings.cleanlinessRating = rating
            print("cleanliness rating = ", rating)
        }
        privacyRating.didFinishTouchingCosmos = {rating in
            Constants.ratings.privacyRating = rating
        }
        essentialsRating.didFinishTouchingCosmos = {rating in
            Constants.ratings.essentialsRating = rating
        }
        smellRating.didFinishTouchingCosmos = {rating in
            Constants.ratings.smellRating = rating
        }
        aestheticRating.didFinishTouchingCosmos = {rating in
            Constants.ratings.aestheticRating = rating
        }
        
    }
    
}
