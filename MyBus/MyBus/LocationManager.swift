//
//  LocationManager.swift
//  MyBus
//
//  Created by Sebastian Fink on 11/1/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import MapKit

private let _sharedInstance = LocationManager()

class LocationManager:NSObject, CLLocationManagerDelegate {
    
    private var coreLocationManager:CLLocationManager!
    
    var lastKnownLocation:CLLocation?
    
    // MARK: - Instantiation
    class var sharedInstance: LocationManager {
        return _sharedInstance
    }
    
    private override init() {
        super.init()
    }
    
    private func setupLocationManager(){
        coreLocationManager = CLLocationManager()
        coreLocationManager.delegate = self
        coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if isLocationAuthorized() {
            startUpdating()
        }
        
    }
    
    func startUpdating(){
        coreLocationManager.startUpdatingLocation()
    }
    
    func stopUpdating(){
        coreLocationManager.stopUpdatingLocation()
    }
    
    
    func isLocationAuthorized() -> Bool {
        let locationServiceAuth = CLLocationManager.authorizationStatus()
        if(locationServiceAuth == .AuthorizedAlways || locationServiceAuth == .AuthorizedWhenInUse) {
            return true
        }
        return false
    }
    
    
    
    
    // MARK: CLLocationManagerDelegate protocol methods
    internal func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let bestLocation:CLLocation = locations.last else {
            return
        }
        
        self.lastKnownLocation = bestLocation
        
    }
    
    internal func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        
    }

    
    
    
    
    
    
    
}