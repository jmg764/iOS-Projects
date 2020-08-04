//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Jonathan Glaser on 3/14/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
