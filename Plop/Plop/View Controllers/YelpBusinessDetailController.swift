//
//  YelpBusinessDetailController.swift
//  Plop
//
//  Created by Jonathan Glaser on 11/13/18.
//  Copyright © 2018 Jonathan Glaser. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseUI


class YelpBusinessDetailController: UIViewController {
    var ref: DatabaseReference!
    fileprivate var _refHandle: DatabaseHandle!
    var reviews: [DataSnapshot]!
    var effect: UIVisualEffect!
    var businessID = Constants.businessID
    var cleanlinessRating: Double! = 0
    var privacyRating: Double! = 0
    var essentialsRating: Double! = 0
    var smellRating: Double! = 0
    var aestheticRating: Double! = 0
    
    
    
    @IBOutlet var dismissImageRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var yelpTableView: UITableView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingsCountLabel: UILabel!
    @IBOutlet weak var ratingsCount: CosmosView!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var currentHoursStatusLabel: UILabel! {
        didSet {
            if currentHoursStatusLabel.text == "Open" {
                currentHoursStatusLabel.textColor = UIColor(displayP3Red: 2/255.0, green: 192/255.0, blue: 97/255.0, alpha: 1.0)
            } else {
                currentHoursStatusLabel.textColor = UIColor(displayP3Red: 209/255.0, green: 47/255.0, blue: 27/255.0, alpha: 1.0)
            }
        }
    }
    @IBAction func addReview(_ sender: Any) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "AddReviewViewController") as! AddReviewViewController
        present(controller, animated: true, completion: nil)
    }
    
    
    var business: YelpBusiness?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Reviews"
        navigationController?.navigationBar.prefersLargeTitles = true
        ratingsCount.settings.fillMode = .precise
        setupTableView()
        
        
        if let business = business, let viewModel = YelpBusinessDetailViewModel(business: business) {
            configure(with: viewModel)
        }
        configureDatabase()
        
//        Database.database().isPersistenceEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Constants.reviews.removeAll()
    }
    
    var yelpDataSource = YelpReviewsDataSource(data: [], reviews: Constants.reviews)

    
    
    
    
    /// Configures the views in the table view's header view
    ///
    /// - Parameter viewModel: View model representation of a YelpBusiness object
    func configure(with viewModel: YelpBusinessDetailViewModel) {
        restaurantNameLabel.text = viewModel.restaurantName
        priceLabel.text = viewModel.price
        ratingsCountLabel.text = viewModel.ratingsCount
        categoriesLabel.text = viewModel.categories
        hoursLabel.text = viewModel.hours
        currentHoursStatusLabel.text = viewModel.currentStatus
    }
    
    // MARK: - Table View
    
    func setupTableView() {
        yelpTableView.dataSource = yelpDataSource
        yelpTableView.delegate = self as? UITableViewDelegate
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
        _refHandle = ref.child(businessID!).observe(.childAdded) { (snapshot: DataSnapshot) in
            Constants.reviews.append(snapshot)
            print("Snapshot = ", snapshot)
            print("Reviews count = ", Constants.reviews.count)
            if let cleanlinessSnapshot = snapshot.childSnapshot(forPath: "cleanliness rating").value as? Double {
                self.cleanlinessRating += cleanlinessSnapshot
            }
            if let privacySnapshot = snapshot.childSnapshot(forPath: "privacy rating").value as? Double {
                self.privacyRating += privacySnapshot
            }
            if let essentialsSnapshot = snapshot.childSnapshot(forPath: "essentials rating").value as? Double {
                self.essentialsRating += essentialsSnapshot
            }
            if let smellSnapshot = snapshot.childSnapshot(forPath: "smell rating").value as? Double {
                self.smellRating += smellSnapshot
            }
            if let aestheticSnapshot = snapshot.childSnapshot(forPath: "essentials rating").value as? Double {
                self.aestheticRating += aestheticSnapshot
            }
            print("average rating = ", self.averageRating())
            self.ratingsCount.rating = self.averageRating()
            self.ratingsCountLabel.text = String(round(self.averageRating()*10)/10)
            
            self.yelpTableView.insertRows(at: [IndexPath(row: Constants.reviews.count - 1, section: 0)], with: .automatic)
            
//            Constants.reviewCache.setObject(snapshot, forKey: Constants.businessID! as NSString)
        }
    }
    
    func averageRating() -> Double {
        var average: Double!
        var cleanlinessAverage = cleanlinessRating/Double(Constants.reviews.count)
        var privacyAverage = privacyRating/Double(Constants.reviews.count)
        var essentialsAverage = essentialsRating/Double(Constants.reviews.count)
        var smellAverage = smellRating/Double(Constants.reviews.count)
        var aestheticAverage = aestheticRating/Double(Constants.reviews.count)
        
        var total = cleanlinessAverage + privacyAverage + essentialsAverage + smellAverage + aestheticAverage
//        print("total = ", total)
        average = total/5
        print("average = ", average)
        
        return average
    }
    
    deinit {
        ref.child("reviews").removeObserver(withHandle: _refHandle)
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    class func sharedInstance() -> YelpBusinessDetailController {
        struct Singleton {
            static var sharedInstance = YelpBusinessDetailController()
        }
        return Singleton.sharedInstance
    }
    
}

