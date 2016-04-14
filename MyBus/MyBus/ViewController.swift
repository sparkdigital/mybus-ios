//
//  ViewController.swift
//  MyBus
//
//  Created by Marcos Vivar on 4/12/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit
import Mapbox

class ViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet var mapView : MGLMapView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.userTrackingMode = .Follow
        mapView.delegate = self
        
        // Double tapping zooms the map, so ensure that can still happen
        let doubleTap = UITapGestureRecognizer(target: self, action: nil)
        doubleTap.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(doubleTap)
        
        // Delay single tap recognition until it is clearly not a double
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleSingleTap(_:)))
        singleTap.requireGestureRecognizerToFail(doubleTap)
        mapView.addGestureRecognizer(singleTap)
    }
    
    func mapView(mapView: MGLMapView, didUpdateUserLocation userLocation: MGLUserLocation?) {
        //Move map to current user location
        mapView.centerCoordinate = (userLocation!.location?.coordinate)!
    }
    
    func handleSingleTap(tap: UITapGestureRecognizer) {
        // Convert tap location (CGPoint) to geographic coordinates (CLLocationCoordinate2D)
        let tappedLocation: CLLocationCoordinate2D = mapView.convertPoint(tap.locationInView(mapView), toCoordinateFromView: mapView)
        
        // Declare the marker point and set its coordinates
        let mapPoint = MGLPointAnnotation()
        mapPoint.coordinate = CLLocationCoordinate2D(latitude: tappedLocation.latitude, longitude: tappedLocation.longitude)
        
        // Remove first marker tapped from the map, add marker with coordinates
        // Prevent having more than two points selected in map
        if (mapView.annotations?.count != nil && mapView.annotations?.count > 1 ) {
            mapView.removeAnnotation(mapView.annotations![0])
        }
        
        // Add marker to the map
        mapView.addAnnotation(mapPoint)
        Connectivity.sharedInstance.getAddressFromCoordinate(tappedLocation.latitude, longitude: tappedLocation.longitude)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

