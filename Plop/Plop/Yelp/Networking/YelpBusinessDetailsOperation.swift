//
//  YelpBusinessDetailsOperation.swift
//  Plop
//
//  Created by Jonathan Glaser on 11/13/18.
//  Copyright © 2018 Jonathan Glaser. All rights reserved.
//

import Foundation

class YelpBusinessDetailsOperation: Operation {
    let business: YelpBusiness
    let client: YelpClient
    
    init(business: YelpBusiness, client: YelpClient) {
        self.business = business
        self.client = client
        super.init()
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    private var _finished = false
    
    override private(set) var isFinished: Bool {
        get {
            return _finished
        }
        
        set {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    private var _executing = false
    
    override private(set) var isExecuting: Bool {
        get {
            return _executing
        }
        set {
            willChangeValue(forKey: "isExecuting")
            _executing = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override func start() {
        if isCancelled {
            isFinished = true
        }
        isExecuting = true
        client.updateWithHoursAndPhotos(business) { [unowned self] result  in
            switch result {
            case .success(_):
                self.isExecuting = false
                self.isFinished = true
            case .failure (let error):
                print(error)
                self.isExecuting = false
                self.isFinished = true
            }
        }
        
        
    }
    
    
}
