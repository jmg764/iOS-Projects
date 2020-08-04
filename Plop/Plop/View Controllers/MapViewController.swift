//
//  MapViewController.swift
//  Plop
//
//  Created by Jonathan Glaser on 11/11/18.
//  Copyright © 2018 Jonathan Glaser. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import Firebase
import FirebaseUI
import GoogleSignIn

class MapViewController: UIViewController, LocationPermissionsDelegate {
    
    var ref: DatabaseReference!
    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    var user: User?
    var displayName = Constants.displayName

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func signOutButton(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    let searchController = UISearchController(searchResultsController: nil)
    
    
    var isAuthorized: Bool {
        let isAuthorizedForLocation = LocationManager.isAuthorized
        
        return isAuthorizedForLocation
    }
    
    lazy var locationManager: LocationManager = {
        return LocationManager(delegate: self, permissionsDelegate: nil)
    }()
    
    lazy var client: YelpClient = {
        
        return YelpClient(session: URLSession.shared)
    }()
    
    let dataSource = YelpSearchResultsDataSource()

    
    var coordinate: Coordinate? {
        didSet {
            if let coordinate = coordinate {
                showNearbyRestaurants(at: coordinate)
            }
        }
    }
    
    let queue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        setupSearchBar()
        setupTableView()
        configureAuth()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if isAuthorized {
            locationManager.requestLocation()
        } else {
            let alert = UIAlertController(title: "Error", message: "Please authorize location use to use Plop", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
        requestLocationPermissions()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureAuth()
    }
    
    
    
    // MARK: Login functions
    
    func signedInStatus(isSignedIn: Bool) {
        if (isSignedIn) {
            configureDatabase()
        }
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
    }
    
    func loginSession() {
        let authViewController = FUIAuth.defaultAuthUI()!.authViewController()
        present(authViewController, animated: true, completion: nil)
    }
    
    deinit {
        Auth.auth().removeStateDidChangeListener(_authHandle)
    }
    
    func configureAuth() {
        let provider: [FUIAuthProvider] = [FUIGoogleAuth()]
        FUIAuth.defaultAuthUI()?.providers = provider
        // listen for changes in the authorization state
        _authHandle = Auth.auth().addStateDidChangeListener { (auth: Auth, user: User?) in
            
            // check if there is a current user
            if let activeUser = user {
                // check if the current app user is the current FIRUser
                if self.user != activeUser {
                    self.user = activeUser
                    self.signedInStatus(isSignedIn: true)
                    let name = user!.email!.components(separatedBy: "@")[0]
                    Constants.displayName = name
                }
            } else {
                // user must sign in
                self.signedInStatus(isSignedIn: false)
                self.loginSession()
            }
            
            
            
        }
    }
    
    //
    
    func setupSearchBar() {
        self.navigationItem.titleView = searchController.searchBar
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
    }
    
    func setupTableView() {
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self as? UITableViewDelegate
    }
    
    func showNearbyRestaurants(at coordinate: Coordinate) {
        client.search(withTerm: "", at: coordinate) { [weak self] result in
            switch result {
            case .success(let businesses):
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.hidesWhenStopped = true
                self?.dataSource.update(with: businesses)
                self?.tableView.reloadData()
                
                self?.mapView.addAnnotations(businesses)
            case .failure(let error):
                print(error)
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.hidesWhenStopped = true
                let alert = UIAlertController(title: "Error", message: "Network request error. Please try again.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(alertAction)
                self?.present(alert, animated: true, completion: nil)
                Constants.networkRequest = false
            }
        }
    }

    
    func requestLocationPermissions() {
        do {
            try locationManager.requestLocationAutorization()
        } catch LocationError.disallowedByUser {
            //Show alert to users
        } catch let error {
            print ("Location Authorization Error: \(error.localizedDescription)")
            Constants.networkRequest = false
            print("Constants.networkRequest = ", Constants.networkRequest)
        }
    }
    
    // MARK: Location Permissions Delegate
    func authorizationSucceeded() {
        debugPrint("Authorization succeeded")
    }
    func authorizationFailedWithStatus(_ status: CLAuthorizationStatus) {
        debugPrint("Authorization failed with status: \(status)")
    }
    
    class func sharedInstance() -> MapViewController {
        struct Singleton {
            static var sharedInstance = MapViewController()
        }
        return Singleton.sharedInstance
    }
}

extension MapViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBusiness" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let business = dataSource.object(at: indexPath)
                let detailController = segue.destination as! YelpBusinessDetailController
                detailController.business = business
                detailController.yelpDataSource.updateData(business.reviews)
            }
        }
    }
}

extension MapViewController: LocationManagerDelegate {
    func obtainedCoordinates(_ coordinate: Coordinate) {
        self.coordinate = coordinate
        adjustMap(with: coordinate)
    }
    
    func failedWithError(_ error: LocationError) {
        debugPrint(error)
    }
}

extension MapViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let business = dataSource.object(at: indexPath)
        Constants.businessID = business.id
        
        let detailsOperation = YelpBusinessDetailsOperation(business: business, client: self.client)
        let reviewsOperation = YelpBusinessReviewsOperation(business: business, client: client)
        reviewsOperation.addDependency(detailsOperation)
        
//        reviewsOperation.completionBlock = {
//            
//        }
        
        DispatchQueue.main.async {
            self.dataSource.update(business, at: indexPath)
            self.performSegue(withIdentifier: "showBusiness", sender: nil)
        }
        
        queue.addOperation(detailsOperation)
        queue.addOperation(reviewsOperation)
    }
}

extension MapViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text, let coordinate = coordinate else { return }
        
        if !searchTerm.isEmpty {
            client.search(withTerm: searchTerm, at: coordinate) { [weak self] result in
                switch result {
                case .success(let businesses):
                    self?.dataSource.update(with: businesses)
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

// MARK: - MapKit
extension MapViewController {
    func adjustMap(with coordinate: Coordinate) {
        let coordinate2D = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let span = MKCoordinateRegion.init(center: coordinate2D, latitudinalMeters: 2500, longitudinalMeters: 2500).span
        let region = MKCoordinateRegion(center: coordinate2D, span: span)
        mapView.setRegion(region, animated: true)
    }
}



