//
//  JSONDecodable.swift
//  Plop
//
//  Created by Jonathan Glaser on 11/11/18.
//  Copyright © 2018 Jonathan Glaser. All rights reserved.
//

import Foundation

protocol JSONDecodable {
    /// Instantiates an instance of the conforming type with a JSON dictionary
    ///
    /// Returns `nil` if the JSON dictionary does not contain all the values
    /// needed for instantiation of the conforming type
    init?(json: [String: Any])
}
