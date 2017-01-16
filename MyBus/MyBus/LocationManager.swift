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
@objc protocol LocationManagerDelegate: NSObjectProtocol {
    func locationFound(_ latitude: Double, longitude: Double) -> Void
    @objc optional func locationManagerReceivedError(_ error: String, localizedDescription: String)
    @objc optional func locationManagerStatus(_ authStatus: CLAuthorizationStatus, authVerboseMessage: String)
}

typealias CLReverseGeocodeCompletionHandler = (_ placemark:CLPlacemark?, _ error:String?) -> ()
typealias GoogleReverseGeocodeCompletionHandler = () -> ()
typealias CurrentLocationFoundHandler = (_ location:CLLocation?, _ error:String?)->()

enum LocationManagerError: String {
    case ReverseGeocodeLocationNotFound = "No location found for given address"
}


private let _sharedInstance = LocationManager()

class LocationManager: NSObject, CLLocationManagerDelegate {

    let verboseMessageDictionary = [CLAuthorizationStatus.notDetermined:Localization.getLocalizedString("Aun_No"),
                                    CLAuthorizationStatus.restricted:Localization.getLocalizedString("Esta_Aplicacion"),
                                    CLAuthorizationStatus.denied:Localization.getLocalizedString("You_have"),
                                    CLAuthorizationStatus.authorizedAlways:Localization.getLocalizedString("La_Aplicacion_Esta"),
                                    CLAuthorizationStatus.authorizedWhenInUse:Localization.getLocalizedString("Ud_Ha_Permitido")]




    fileprivate var coreLocationManager: CLLocationManager!

    var lastKnownLocation: CLLocation?
    var locationDelegate: LocationManagerDelegate?
    var currentLocationHandler: CurrentLocationFoundHandler?

    var verboseMessage: String = ""
    var locationStatus: CLAuthorizationStatus = CLAuthorizationStatus.notDetermined

    var autoUpdate: Bool = false
    var isLocationServiceRunning: Bool = false

    // MARK: - Instantiation
    class var sharedInstance: LocationManager {
        return _sharedInstance
    }

    fileprivate override init() {
        super.init()
    }

    fileprivate func setupLocationManager(){
        coreLocationManager = CLLocationManager()
        coreLocationManager.distanceFilter = 200
        coreLocationManager.delegate = self
        coreLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation

        if CLLocationManager.locationServicesEnabled() {
            startUpdating()
        }

    }

    func startUpdatingWithCompletionHandler(_ handler:@escaping CurrentLocationFoundHandler){
        self.currentLocationHandler = handler
        setupLocationManager()
    }

    func startUpdating(){
        coreLocationManager.startUpdatingLocation()
    }

    func stopUpdating(){
        coreLocationManager.stopUpdatingLocation()
    }

    func requestAuthorization(){
        setupLocationManager()
        self.coreLocationManager.requestWhenInUseAuthorization()
    }

    func isLocationAuthorized() -> Bool {
        let locationServiceAuth = CLLocationManager.authorizationStatus()
        if(locationServiceAuth == .authorizedAlways || locationServiceAuth == .authorizedWhenInUse) {
            return true
        }
        return false
    }


    fileprivate func resetLocation(){
        self.lastKnownLocation = nil
    }

    // MARK: CLLocationManagerDelegate protocol methods
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let bestLocation: CLLocation = locations.last else {
            return
        }

        self.lastKnownLocation = bestLocation

        if let delegate = locationDelegate {
            delegate.locationFound(bestLocation.coordinate.latitude, longitude: bestLocation.coordinate.longitude)
        }

        if let handler = currentLocationHandler {
            handler(bestLocation, nil)
            currentLocationHandler = nil
        }



    }

    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){

        resetLocation()

        //send a nsnotification?
        if let handler = currentLocationHandler {
            handler(nil, error.localizedDescription)
        }
    }


    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let hasAuthorized = (status == CLAuthorizationStatus.authorizedAlways) ||
        (status == CLAuthorizationStatus.authorizedWhenInUse)

        verboseMessage = verboseMessageDictionary[status]!

        if hasAuthorized {
            startUpdating()
        }else{
            resetLocation()

            if let delegate = locationDelegate {
                delegate.locationManagerStatus?(status, authVerboseMessage: verboseMessage)
            }

            if let handler = currentLocationHandler {
                handler(nil, verboseMessage)
            }

        }

    }




    // MARK: Apple Reverse Geocoding
    func CLReverseGeocoding(_ latitude: Double, longitude: Double, handler:@escaping CLReverseGeocodeCompletionHandler){

        let location: CLLocation = CLLocation(latitude: latitude, longitude: longitude)

        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in

            if let err = error {
                return handler(nil, err.localizedDescription)
            }

            guard let placemark = placemarks?.first else {
                return handler(nil, LocationManagerError.ReverseGeocodeLocationNotFound.rawValue)
            }

            handler(placemark, nil)

        }

    }

    // MARK: Google Reverse Geocoding
    func googleReverseGeocoding(_ location:(latitude: Double, longitude: Double)){
    }


}
