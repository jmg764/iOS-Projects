//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Jonathan Glaser on 9/17/18.
//  Copyright © 2018 Jonathan Glaser. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    var dataController: DataController!
    var pins: [Pin] = []
    var currentPin: Pin!
    var pinHasPhotos: Bool!
    var annotation = MKPointAnnotation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        self.title = "Virtual Tourist"
        
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        if let result = try? dataController.viewContext.fetch(fetchRequest){
            pins = result
        }
        
        for pin in pins {
            let lat = CLLocationDegrees(pin.latitude)
            let long = CLLocationDegrees(pin.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            self.mapView.addAnnotation(annotation)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        if let result = try? dataController.viewContext.fetch(fetchRequest){
            pins = result
        }
        
        for pin in pins {
            let lat = CLLocationDegrees(pin.latitude)
            let long = CLLocationDegrees(pin.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            self.mapView.addAnnotation(annotation)
        }
    }
    
    @IBAction func dropPin(sender: UILongPressGestureRecognizer) {
        var location = sender.location(in: self.mapView)
        var coordinate = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        if sender.state == UIGestureRecognizerState.began {
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
        else if sender.state == UIGestureRecognizerState.changed {
            //mapView.removeAnnotation(annotation)
            location = sender.location(in: self.mapView)
            coordinate = self.mapView.convert(location, toCoordinateFrom: self.mapView)
            annotation.coordinate = coordinate
            Constants.coordinate = coordinate
        }
        else if sender.state == UIGestureRecognizerState.ended {
            //self.mapView.removeAnnotation(annotation)
            location = sender.location(in: self.mapView)
            coordinate = self.mapView.convert(location, toCoordinateFrom: self.mapView)
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            Constants.annotations.append(annotation)
            Constants.coordinate = coordinate
            
            // Save pin from the context to the persistent store
            let pin = Pin(context: dataController.viewContext)
            pin.latitude = coordinate.latitude
            pin.longitude = coordinate.longitude
            try? dataController.viewContext.save()
            
            self.currentPin = pin
            pins.append(pin)
            self.pinHasPhotos = false
            Constants.currentPin = currentPin
            Constants.photosExist = pinHasPhotos
            
            Constants.dataController = dataController
            performSegue(withIdentifier: "PhotoAlbumIdentifier", sender: nil)

        }
    }
    
    @IBAction func clearPins(_ sender: Any) {
        for pin in pins {
            dataController.viewContext.delete(pin)
        }
        if currentPin != nil {
            dataController.viewContext.delete(currentPin)
        }
        self.mapView.removeAnnotations(mapView.annotations)
        try? dataController.viewContext.save()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .red
            pinView!.animatesDrop = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else {
            return
        }
        
        let lat = annotation.coordinate.latitude
        let long = annotation.coordinate.longitude
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        for pin in pins {
            if pin.latitude == coordinate.latitude && pin.longitude == coordinate.longitude {
                self.currentPin = pin
            }
        }
        
        Constants.coordinate = coordinate
        Constants.currentPin = currentPin
        Constants.dataController = dataController
        self.pinHasPhotos = true
        Constants.photosExist = pinHasPhotos
        
        mapView.deselectAnnotation(annotation, animated: true)
        
        performSegue(withIdentifier: "PhotoAlbumIdentifier", sender: nil)
        debugPrint("Pin pressed")
    }
    
    
    
}
