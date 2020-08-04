//
//  YelpSearchResultsDataSource.swift
//  Plop
//
//  Created by Jonathan Glaser on 11/12/18.
//  Copyright © 2018 Jonathan Glaser. All rights reserved.
//

import Foundation
import UIKit

class YelpSearchResultsDataSource: NSObject, UITableViewDataSource {
    
    private var data = [YelpBusiness]()
    
    
    override init() {
        super.init()
    }
    
    // MARK: Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        
        let business = object(at: indexPath)
        cell.textLabel?.text = business.name
        Constants.restaurantNames.append(business.name)
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Restaurants"
        default: return nil
        }
    }
    
    // MARK: Helpers
    
    func object(at indexPath: IndexPath) -> YelpBusiness {
        return data[indexPath.row]
    }
    
    func update(with data: [YelpBusiness]) {
        self.data = data
    }
    
    func update(_ object: YelpBusiness, at indexPath: IndexPath) {
        data[indexPath.row] = object
    }
    
    class func sharedInstance() -> YelpSearchResultsDataSource {
        struct Singleton {
            static var sharedInstance = YelpSearchResultsDataSource()
        }
        return Singleton.sharedInstance
    }
}
