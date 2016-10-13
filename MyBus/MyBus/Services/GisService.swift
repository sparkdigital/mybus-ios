//
//  MGPGisService.swift
//  MyBus
//
//  Created by Lisandro Falconi on 5/28/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import SwiftyJSON
import MapKit

protocol GisServiceDelegate {
    func getStreetNamesByFile(forName address: String, completionHandler: ([String]?, NSError?) -> ())
    func getAddressFromCoordinate(latitude: Double, longitude: Double, completionHandler: (RoutePoint?, NSError?) -> ())
}

public class GisService: NSObject, GisServiceDelegate {

    func getStreetNamesByFile(forName address: String, completionHandler: ([String]?, NSError?) -> ())
    {
        let streets = Configuration.streetsName()

        guard streets.count > 0 else {
            let error: NSError = NSError(domain:"street plist", code:2, userInfo:nil)
            return completionHandler(nil, error)
        }
        let streetsFiltered = streets.filter{($0.lowercaseString).containsString(address.lowercaseString)}
        completionHandler(streetsFiltered, nil)
    }

    func getAddressFromCoordinate(latitude: Double, longitude: Double, completionHandler: (RoutePoint?, NSError?) -> ())
    {
        print("You tapped at: \(latitude), \(longitude)")
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) {
            placemarks, error in
            if let placemark = placemarks?.first {
                let point = RoutePoint()
                point.latitude = latitude
                point.longitude = longitude
                if let street = placemark.thoroughfare, let houseNumber = placemark.subThoroughfare {
                    let address = "\(street as String) \(houseNumber as String)"
                    point.address = address
                }
                completionHandler(point, nil)
            }else{
                completionHandler(nil, error)
            }
            
        }
    }
}
