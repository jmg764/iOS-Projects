//
//  GCDBlackbox.swift
//  Virtual Tourist
//
//  Created by Jonathan Glaser on 9/17/18.
//  Copyright © 2018 Jonathan Glaser. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
