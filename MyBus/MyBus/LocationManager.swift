//
//  LocationManager.swift
//  MyBus
//
//  Created by Sebastian Fink on 11/1/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import MapKit


//LocationManagerDelegate protocol
@objc protocol LocationManagerDelegate:NSObjectProtocol {
    func locationFound(latitude:Double, longitude:Double) -> Void
    optional func locationManagerReceivedError(error:String, localizedDescription:String)
    optional func locationManagerStatus(authStatus:CLAuthorizationStatus, authVerboseMessage:String)
}

typealias CLReverseGeocodeCompletionHandler = (placemark:CLPlacemark?, error:String?) -> ()
typealias GoogleReverseGeocodeCompletionHandler = () -> ()
typealias CurrentLocationFoundHandler = (location:CLLocation?, error:String?)->()

enum LocationManagerError:String {
    case ReverseGeocodeLocationNotFound = "No location found for given address"
}


private let _sharedInstance = LocationManager()

class LocationManager:NSObject, CLLocationManagerDelegate {
    
    let verboseMessageDictionary = [CLAuthorizationStatus.NotDetermined:"Aun no ha determinado los permisos de geolocalización de esta aplicación.",
                                    CLAuthorizationStatus.Restricted:"Esta aplicación no esta autorizada a utilizar servicios de geolocalización.",
                                    CLAuthorizationStatus.Denied:"You have explicitly denied authorization for this application, or location services are disabled in Settings.",
                                    CLAuthorizationStatus.AuthorizedAlways:"La aplicación esta autorizada a utilizar servicios de ubicación.",
                                    CLAuthorizationStatus.AuthorizedWhenInUse:"Ud ha permitido el uso de su ubicación solo cuando la aplicación esté siendo utilizada."]

    
    
    
    private var coreLocationManager:CLLocationManager!
    
    var lastKnownLocation:CLLocation?
    var locationDelegate:LocationManagerDelegate?
    var currentLocationHandler:CurrentLocationFoundHandler?
    
    var verboseMessage:String = ""
    var locationStatus:CLAuthorizationStatus = CLAuthorizationStatus.NotDetermined
    
    var autoUpdate:Bool = false
    var isLocationServiceRunning:Bool = false
    
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
        
        if CLLocationManager.locationServicesEnabled() {
            startUpdating()
        }
        
    }
    
    func startUpdatingWithCompletionHandler(handler:CurrentLocationFoundHandler){
        self.currentLocationHandler = handler
        setupLocationManager()
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
    
    
    private func resetLocation(){
        self.lastKnownLocation = nil
    }
    
    // MARK: CLLocationManagerDelegate protocol methods
    internal func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let bestLocation:CLLocation = locations.last else {
            return
        }
        
        self.lastKnownLocation = bestLocation
        
        if let delegate = locationDelegate {
            delegate.locationFound(bestLocation.coordinate.latitude, longitude: bestLocation.coordinate.longitude)
        }
        
        if let handler = currentLocationHandler {
            handler(location: bestLocation, error: nil)
            stopUpdating()            
            currentLocationHandler = nil
        }
        
        
        
    }
    
    internal func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        
        stopUpdating()
        resetLocation()
        
        //send a nsnotification?
        if let handler = currentLocationHandler {
            handler(location: nil, error: error.localizedDescription)
        }
    }
    
    
    internal func locationManager(manager: CLLocationManager,didChangeAuthorization status: CLAuthorizationStatus) {
        let hasAuthorized = (status == CLAuthorizationStatus.AuthorizedAlways) ||
        (status == CLAuthorizationStatus.AuthorizedWhenInUse)
        
        verboseMessage = verboseMessageDictionary[status]!
        
        if hasAuthorized {
            setupLocationManager()
        }else{
            resetLocation()
            
            if let delegate = locationDelegate {
                delegate.locationManagerStatus?(status, authVerboseMessage: verboseMessage)
            }
            
            if let handler = currentLocationHandler {
                handler(location: nil, error: verboseMessage)
            }
           
        }
       
    }
    
    
    
    
    // MARK: Apple Reverse Geocoding
    func CLReverseGeocoding(latitude:Double, longitude:Double, handler:CLReverseGeocodeCompletionHandler){
        
        let location:CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            
            if let err = error {
                return handler(placemark: nil, error: err.localizedDescription)
            }
           
            guard let placemark = placemarks?.first else {
                return handler(placemark: nil, error: LocationManagerError.ReverseGeocodeLocationNotFound.rawValue)
            }
            
            handler(placemark: placemark, error: nil)
           
        }
       
    }
    
    // MARK: Google Reverse Geocoding
    func googleReverseGeocoding(location:(latitude:Double,longitude:Double)){
    }
    
    
}