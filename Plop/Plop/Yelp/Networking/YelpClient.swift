//
//  YelpClient.swift
//  Plop
//
//  Created by Jonathan Glaser on 11/11/18.
//  Copyright © 2018 Jonathan Glaser. All rights reserved.
//

import Foundation

class YelpClient: APIClient {
    var apiKey: String {
        // ideally fetched from keychain or somewhere secure
        return "P7tHztQFBPf7G13td85jW7IJXejEVo1OzgWgarlvZjv80k5FBG79hYDN-OatnYFs9_aN53RvjG75SuijJ3pl7gAlkgVOBrDmVBCqnG1qt-LfzAaDw5CskfVQtaLnW3Yx"
    }
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func searchBusinesses() {
        let endpoint = Yelp.business(id: "rn1OLn-GYBISaxcxdrpbNw")
        // Inside the client, when we retrieve the request object from the endpoint, we're
        // passing in the apiKey
        let request = endpoint.request(withApiKey: apiKey)
        
        // Do the usual stuff!
    }
    
    func search(withTerm term: String, at coordinate: Coordinate, radius: Int? = nil, limit: Int = 50, sortBy sortType: Yelp.YelpSortType = .rating, completion: @escaping (Result<[YelpBusiness], APIError>) -> Void) {
        
        let endpoint = Yelp.search(term: term, coordinate: coordinate, radius: radius, limit: limit, sortBy: sortType)
        
        let request = endpoint.request(withApiKey: apiKey)
        print(request)
        fetch(with: request, parse: { (json) -> [YelpBusiness] in
            guard let businesses = json["businesses"] as? [[String: Any]] else {return []}
            return businesses.compactMap {YelpBusiness(json: $0)}
        }, completion: completion)
    }
    
    func businessWithID(_ id: String, completion: @escaping(Result<YelpBusiness, APIError>) -> Void) {
        let endpoint = Yelp.business(id: id)
        let request = endpoint.request(withApiKey: apiKey)
        
        fetch(with: request, parse: { json -> YelpBusiness? in
            return YelpBusiness(json: json)
        }, completion: completion)
    }
    
    func updateWithHoursAndPhotos(_ business: YelpBusiness, completion: @escaping(Result<YelpBusiness, APIError>) -> Void) {
        let endpoint = Yelp.business(id: business.id)
        let request = endpoint.request(withApiKey: apiKey)
        
        fetch(with: request, parse: { json -> YelpBusiness? in
            business.updateWithHoursAndPhotos(json: json)
            return business
        }, completion: completion)
        
    }
    
    func reviews(for business: YelpBusiness, completion: @escaping (Result<[YelpReview], APIError>) -> Void) {
        let endpoint = Yelp.reviews(businessId: business.id)
        print("endpoint = ", endpoint)
        let request = endpoint.request(withApiKey: apiKey)
        
        fetch(with: request, parse: { json -> [YelpReview] in
            guard let reviews = json["reviews"] as? [[String: Any]] else { return [] }
            return reviews.compactMap { YelpReview(json: $0)}
        }, completion: completion)
    }
    
//    func search(withTerm term: String, at coordinate: Coordinate, categories: [YelpCategory] = [], radius: Int? = nil, limit: Int = 50, sortBy sortType: Yelp.YelpSortType = .rating, completion: @escaping (Result<[YelpBusiness], APIError>) -> Void) {
//
//        let endpoint = Yelp.search(term: term, coordinate: coordinate, radius: radius, categories: categories, limit: limit, sortBy: sortType)
//
//        let request = endpoint.request(withApiKey: apiKey)
//        print(request)
//        fetch(with: request, parse: { (json) -> [YelpBusiness] in
//            guard let businesses = json["businesses"] as? [[String: Any]] else {return []}
//            return businesses.compactMap {YelpBusiness(json: $0)}
//        }, completion: completion)
//    }
}


