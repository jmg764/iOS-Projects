//
//  Coordinate.swift
//  Plop
//
//  Created by Jonathan Glaser on 11/11/18.
//  Copyright © 2018 Jonathan Glaser. All rights reserved.
//

import Foundation

struct Coordinate {
    let latitude: Double
    let longitude: Double
}

extension Coordinate: Decodable {
    init?(json: [String : Any]) {
        guard let latitudeValue = json["latitude"] as? Double, let longitudeValue = json["longitude"] as? Double else { return nil }
        self.latitude = latitudeValue
        self.longitude = longitudeValue
    }
}
