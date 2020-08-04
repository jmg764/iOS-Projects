//
//  Endpoint.swift
//  Plop
//
//  Created by Jonathan Glaser on 11/11/18.
//  Copyright © 2018 Jonathan Glaser. All rights reserved.
//

import Foundation

protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = queryItems
        return components
    }
    
    // Note here that instead of a computed property that returns a request, we're
    // defining a function in the protocol extension that takes the apiKey and adds it to the
    // header
    func request(withApiKey key: String) -> URLRequest {
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}


enum Yelp {
    enum YelpSortType: CustomStringConvertible {
        case bestMatch, rating, reviewCount, distance
        
        var description: String {
            switch self {
            case .bestMatch: return "best_match"
            case .rating: return "rating"
            case .reviewCount: return "review_count"
            case .distance: return "distance"
            }
        }
    }
    
    case search(term: String, coordinate: Coordinate, radius: Int?, limit: Int?, sortBy: YelpSortType?)
//    case search(term: String, coordinate: Coordinate, radius: Int?, categories: [YelpCategory], limit: Int?, sortBy: YelpSortType?)
    case business(id: String)
    case reviews(businessId: String)
}

extension Yelp: Endpoint {
    var base: String {
        return "https://api.yelp.com"
    }
    
    var path: String {
        switch self {
        case .search: return "/v3/businesses/search"
        case .business(let id): return "/v3/businesses/\(id)"
        case .reviews(let id): return "/v3/businesses/\(id)/reviews"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .search(let term, let coordinate, let radius, let limit, let sortBy):
            return [
                URLQueryItem(name: "term", value: term),
                URLQueryItem(name: "latitude", value: coordinate.latitude.description),
                URLQueryItem(name: "longitude", value: coordinate.longitude.description),
                URLQueryItem(name: "radius", value: radius?.description),
                URLQueryItem(name: "limit", value: limit?.description),
                URLQueryItem(name: "sort_by", value: sortBy?.description)
            ]
        case .business: return []
        case .reviews: return []
        }
    }
    
//    var queryItems: [URLQueryItem] {
//        switch self {
//        case .search(let term, let coordinate, let radius, let categories, let limit, let sortBy):
//            return [
//                URLQueryItem(name: "term", value: term),
//                URLQueryItem(name: "latitude", value: coordinate.latitude.description),
//                URLQueryItem(name: "longitude", value: coordinate.longitude.description),
//                URLQueryItem(name: "radius", value: radius?.description),
//                URLQueryItem(name: "categories", value: categories.map({$0.alias}).joined(separator: ",")),
//                URLQueryItem(name: "limit", value: limit?.description),
//                URLQueryItem(name: "sort_by", value: sortBy?.description)
//            ]
//        case .business: return []
//        case .reviews: return []
//        }
//    }
}

class YelpAPIClient {
    
}
