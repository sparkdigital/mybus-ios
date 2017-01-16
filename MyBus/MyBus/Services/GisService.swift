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
    func getAddressFromCoordinate(_ latitude: Double, longitude: Double, completionHandler: @escaping (RoutePoint?, NSError?) -> ())
}

open class GisService: NSObject, GisServiceDelegate {

    internal func getStreetNamesByFile(forName address: String, completionHandler: ([String]?, NSError?) -> ())
    {
        let streets = Configuration.streetsName()

        guard streets.count > 0 else {
            let error: NSError = NSError(domain:"street plist", code:2, userInfo:nil)
            return completionHandler(nil, error)
        }
        let streetsFiltered = streets.filter{($0.lowercased()).contains(address.lowercased())}
        completionHandler(streetsFiltered, nil)
    }

    internal func getAllStreetNamesByFile(_ completionHandler: ([String]?, NSError?) -> ())
    {
        let streets = Configuration.streetsName()

        guard streets.count > 0 else {
            let error: NSError = NSError(domain:"street plist", code:2, userInfo:nil)
            return completionHandler(nil, error)
        }

        completionHandler(streets, nil)
    }

    internal func getAddressFromCoordinate(_ latitude: Double, longitude: Double, completionHandler: @escaping (RoutePoint?, NSError?) -> ())
    {
        print("You tapped at: \(latitude), \(longitude)")
        let validLocalities = ["general pueyrredón", "mar del plata", "sierra de los padres", "batán"]

        LocationManager.sharedInstance.CLReverseGeocoding(latitude, longitude: longitude) { (placemark, error) in

            if let e = error {
                let convertedError = NSError(domain: "No Location found", code: 2, userInfo: [NSLocalizedDescriptionKey:e])
                return completionHandler(nil, convertedError)
            }

            guard let locality = placemark?.locality, validLocalities.contains(locality.lowercased()) else {
                let invalidLocalityError = NSError(domain: "Location Error Domain", code: 2, userInfo: [NSLocalizedDescriptionKey:"Invalid locality found"])
                return completionHandler(nil, invalidLocalityError)
            }

            let point = RoutePoint()
            point.latitude = latitude
            point.longitude = longitude
            if let street = placemark?.thoroughfare, let houseNumber = placemark?.subThoroughfare {
                let streetName = (street as String).replacingOccurrences(of: "Calle ", with: "")
                let house = (houseNumber as String).components(separatedBy: "–").first!
                let address = "\(streetName) \(house)"
                point.address = address
            } else {
                point.address = locality
            }
            completionHandler(point, nil)


        }


    }
}
