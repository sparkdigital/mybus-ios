//
//  MGPGisService.swift
//  MyBus
//
//  Created by Lisandro Falconi on 5/28/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol GisServiceDelegate {
    func getStreetNamesByFile(forName address: String, completionHandler: ([String]?, NSError?) -> ())
    func getAddressFromCoordinate(latitude: Double, longitude: Double, completionHandler: (JSON?, NSError?) -> ())
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

    public func getAddressFromCoordinate(latitude: Double, longitude: Double, completionHandler: (JSON?, NSError?) -> ())
    {
        print("You tapped at: \(latitude), \(longitude)")
        /*
         Sample of the response returned by the api for a given coordinate
         
         [GIS SERVICE] Address Found! -> 
         {
            "calle" : "CATAMARCA",
            "codcalle" : "00457",
            "altura" : "1300"
         }
         
         */
        
        let request = GISRouter.CoordinateToAddress(latitude: latitude, longitude: longitude).URLRequest
        BaseNetworkService.performRequest(request, completionHandler: completionHandler)
    }
}
