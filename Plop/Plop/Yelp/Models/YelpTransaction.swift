//
//  YelpTransaction.swift
//  Plop
//
//  Created by Jonathan Glaser on 11/12/18.
//  Copyright © 2018 Jonathan Glaser. All rights reserved.
//

import Foundation

enum YelpTransaction {
    case pickup, delivery, restaurantReservation
}

extension YelpTransaction {
    init?(rawValue: String) {
        switch rawValue {
        case "pickup": self = .pickup
        case "delivery": self = .delivery
        case "restaurant_reservation": self = .restaurantReservation
        default: return nil
        }
    }
}
