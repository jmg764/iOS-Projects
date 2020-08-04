//
//  Constants.swift
//  Virtual Tourist
//
//  Created by Jonathan Glaser on 9/17/18.
//  Copyright © 2018 Jonathan Glaser. All rights reserved.
//

import Foundation
import MapKit

class Constants {
    
    static let APIScheme = "https"
    static let APIHost = "api.flickr.com"
    static let APIPath = "/services/rest"
    
    struct FlickrParameterKeys{
        static let Method = "method"
        static let APIKey = "api_key"
        static let GalleryID = "gallery_id"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Text = "text"
        static let Page = "page"
    }
    
    struct FlickrParameterValues{
        static let SearchMethod = "flickr.photos.search"
        static let APIKey = "30013e900016cec5cf80cdf280ae0da0"
        static let responseFormat = "json"
        static let DisableJSONCallback = "1" /* 1 means "yes" */
        static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
        static let GalleryID = "5704-72157622566655097"
        static let MediumURL = "url_m"
        static let UseSafeSearch = "1"
    }
    
    // MARK: Flickr Response Keys
    struct FlickrResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
        static let Pages = "pages"
        static let Total = "total"
    }
    
    // MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
    
    struct Methods {
        static let photoSearchUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Constants.FlickrParameterValues.APIKey)&format=json&nojsoncallback=1"
    }
    
    struct pinPhoto: Decodable {
        var id: String?
        var owner: String?
        var secret: String?
        var server: String?
        var farm: Int?
        var title: String?
        var ispublic: Int?
        var isfriend: Int?
        var isfamily: Int?
    }
    
    struct PhotoResults: Decodable {
        var photos: Photos?
        var stat: String?
    }
    
    
    struct Photos: Decodable {
        var page: Int?
        var pages: Int?
        var perpage: Int?
        var total: String?
        var photo: [pinPhoto]?
    }
    
    static var annotations = [MKPointAnnotation]()
    static var coordinate: CLLocationCoordinate2D? = nil
    static var currentPin: Pin! = nil
    static var photosExist: Bool! = false
    static var dataController: DataController!
}
