//
//  Constants.swift
//  Plop
//
//  Created by Jonathan Glaser on 11/23/18.
//  Copyright © 2018 Jonathan Glaser. All rights reserved.
//

import Foundation
import Firebase
import FirebaseUI
import CoreData

struct Constants {
    
    struct MessageFields {
        static let name = "name"
        static let text = "text"
        static let imageUrl = "photoUrl"
        static let images = "images"
    }
    
    struct ratings {
        static var cleanlinessRating: Double = 0
        static var privacyRating: Double = 0
        static var essentialsRating: Double = 0
        static var smellRating: Double = 0
        static var aestheticRating: Double = 0
    }
    
    static var reviews: [DataSnapshot]! = []
    static var displayName: String!
    static var reviewImage: UIImage!
    static var imagesArray: [Int: [UIImage]] = [:]
    static var selectedIndexPath: IndexPath!
    static var businessID: String!
    static var networkRequest: Bool = true
    static var restaurantNames: [String] = []
    static var dataController: DataController!
    static var reviewCache = NSCache<NSString, DataSnapshot>()
    
}
