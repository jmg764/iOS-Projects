//
//  FlickrConvenience.swift
//  Virtual Tourist
//
//  Created by Jonathan Glaser on 10/20/18.
//  Copyright © 2018 Jonathan Glaser. All rights reserved.
//

import Foundation

class FlickrConvenience: NSObject {
    
    // MARK: Pull photos for the location of the pin selected
    func getPhotosForLocation (latitude: Double, longitude: Double, completionHandler: @escaping (_ success: Bool, _ errorString: String?, _ dataArray: [Data], _ urlArray: [URL]) -> Void ) {
        let urlString = "\(Constants.Methods.photoSearchUrl)&lat=\(latitude)&lon=\(longitude)&per_page=30"
        print("urlString = ", urlString)
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionHandler(false, "An error occurred with the URL request: \(error!)", [], [])
                return
            }
            
            guard let data = data else {
                completionHandler(false, "Unable to locate data in request", [], [])
                return
            }
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode! <= 299 && statusCode! >= 200 else {
                completionHandler(false, "Request failed. Status code \(statusCode!). Please try again later.", [], [])
                return
            }
            
            var parsedResults: Constants.PhotoResults
            do {
                parsedResults = try JSONDecoder().decode(Constants.PhotoResults.self, from: data)
            } catch {
                debugPrint("Could not parse the data")
                return
            }
            
            /* GUARD: Did Flickr return an error (stat != ok)? */
            guard let stat = parsedResults.stat, stat == Constants.FlickrResponseValues.OKStatus else {
                debugPrint("Flickr API returned an error. See error code and message in \(parsedResults)")
                return
            }
            
            guard let photosDictionary = parsedResults.photos else {
                debugPrint("Cannot find key '\(Constants.FlickrResponseKeys.Photos) in \(parsedResults)")
                return
            }
            
            guard let totalPages = photosDictionary.pages else {
                debugPrint("Cannot find key '\(Constants.FlickrResponseKeys.Pages) in \(photosDictionary)")
                return
            }
            
            let pageLimit = min(totalPages, 4000/30)
            let randomPage = Int(arc4random_uniform(UInt32(pageLimit))) + 1
            
            
            self.getPhotosForLocation(latitude: latitude, longitude: longitude, withPageNumber: randomPage, completionHandler: { (success, error, dataArray, urlArray) in
                if success {
                    parsedResults.photos?.page = randomPage
                }
                if error != nil {
                    debugPrint("Error passing data to getPhotosForLocation")
                }
                completionHandler(success, error, dataArray, urlArray)
                
            })
        }
        task.resume()
    }

    // MARK: Obtain data for random page
    func getPhotosForLocation (latitude: Double, longitude: Double, withPageNumber: Int, completionHandler: @escaping (_ success: Bool, _ errorString: String?, _ dataArray: [Data], _ urlArray: [URL]) -> Void ) {
        let urlString = "\(Constants.Methods.photoSearchUrl)&lat=\(latitude)&lon=\(longitude)&per_page=30&page=\(withPageNumber)"
        print("urlString2 = ", urlString)
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionHandler(false, "An error occured with the URL request: \(error!)", [], [])
                return
            }

            guard let data = data else {
                completionHandler(false, "Unable to locate data in request", [], [])
                return
            }

            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode! <= 299 && statusCode! >= 200 else {
                completionHandler(false, "Request failed. Status code \(statusCode!). Please try again later.", [], [])
                return
            }

            do {
                let parsedResults = try JSONDecoder().decode(Constants.PhotoResults.self, from: data)
                var photoData: [Data] = []
                var photoId: [String] = []
                var photoURL: [URL] = []
                for photo in (parsedResults.photos?.photo!)! {
                    let imageData = try? Data(contentsOf: self.pinPhotoToURL(photo: photo))
                    photoData.append(imageData!)
                    photoId.append(photo.id!)
                    photoURL.append(self.pinPhotoToURL(photo: photo))
                }
                completionHandler(true, nil, photoData, photoURL)
                print("This many properties are being passed: \(photoData.count)")
                return
            } catch {
                completionHandler(false, "Data parse failed:\(error)", [], [])
                return
            }
        }
        task.resume()
    }

    
    //takes in a pinPhoto object and returns a url to be used as image data
    func pinPhotoToURL (photo: Constants.pinPhoto) -> URL {
        return URL(string: "https://farm\(photo.farm!).staticflickr.com/\(photo.server!)/\(photo.id!)_\(photo.secret!).jpg")!
    }
    
    // MARK: Singleton
    class func sharedInstance() -> FlickrConvenience {
        struct Singleton {
            static var sharedInstance = FlickrConvenience()
        }
        return Singleton.sharedInstance
    }
}
