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


private let municipalityBaseURL = "http://gis.mardelplata.gob.ar/opendata/ws.php?method=rest"

private let municipalityAccessToken = "rwef3253465htrt546dcasadg4343"

private let streetNamesEndpointURL = "\(municipalityBaseURL)&endpoint=callejero_mgp&token=\(municipalityAccessToken)&nombre_calle="

private let addressToCoordinateEndpointURL = "\(municipalityBaseURL)&endpoint=callealtura_coordenada&token=\(municipalityAccessToken)"

private let coordinateToAddressEndpointURL = "\(municipalityBaseURL)&endpoint=coordenada_calleaaltura&token=\(municipalityAccessToken)"

public class GisService: NSObject, GisServiceDelegate {

    func getStreetNamesByFile(forName address: String, completionHandler: ([String]?, NSError?) -> ())
    {
        let streetsArray = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("Streets", ofType: "plist")!)

        if let streets = streetsArray {
            let streetsFiltered = (streets as! [String]).filter{($0.lowercaseString).containsString(address.lowercaseString)}
            completionHandler(streetsFiltered, nil)
        }
        else{
            let error: NSError = NSError(domain:"street plist", code:2, userInfo:nil)
            completionHandler(nil, error)
        }
    }

    public func getAddressFromCoordinate(latitude: Double, longitude: Double, completionHandler: (JSON?, NSError?) -> ())
    {
        print("You tapped at: \(latitude), \(longitude)")
        let addressFromCoordinateURLString = "\(coordinateToAddressEndpointURL)&latitud=\(latitude)&longitud=\(longitude)"

        BaseNetworkService().performRequest(addressFromCoordinateURLString, completionHandler: completionHandler)
    }
}
