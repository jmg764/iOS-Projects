//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Jonathan Glaser on 3/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

extension ParseClient {
    
    //MARK: Constants
    struct Constants {
        //MARK API Key
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        //MARK Parse URL
        static let ParseScheme = "https"
        static let ParseHost = "parse.udacity.com"
        static let ParsePath = "/parse/classes"
        static let ParseBaseURL = "https://parse.udacity.com/parse/classes"
    }
    
        
    struct Methods {
        
        static let StudentLocation = "/StudentLocation"

    }
        
    struct JSONResponseKeys{
        static let Results = "results"
        static var ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
    }
        
    struct JSONRequestKeys{
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    struct ParameterKeys {
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        static let Where = "where"
    }
    
    struct HeaderKeys {
        
        static let ParseAppID = "X-Parse-Application-Id"
        static let ParseRESTAPIKey = "X-Parse-REST-API-Key"
    }
    
    

}
