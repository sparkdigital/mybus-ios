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
    func getStreetNames(forName address: String, completionHandler: ([Street]?, NSError?) -> ())
    func getAddressFromCoordinate(latitude: Double, longitude: Double, completionHandler: (JSON?, NSError?) -> ())
}


private let municipalityBaseURL = "http://gis.mardelplata.gob.ar/opendata/ws.php?method=rest"

private let municipalityAccessToken = "rwef3253465htrt546dcasadg4343"

private let streetNamesEndpointURL = "\(municipalityBaseURL)&endpoint=callejero_mgp&token=\(municipalityAccessToken)&nombre_calle="

private let addressToCoordinateEndpointURL = "\(municipalityBaseURL)&endpoint=callealtura_coordenada&token=\(municipalityAccessToken)"

private let coordinateToAddressEndpointURL = "\(municipalityBaseURL)&endpoint=coordenada_calleaaltura&token=\(municipalityAccessToken)"

public class GisService: NSObject, GisServiceDelegate {
    func getStreetNames(forName address: String, completionHandler: ([Street]?, NSError?) -> ())
    {
        let escapedStreet = address.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())! as String
        let streetNameURLString = "\(streetNamesEndpointURL)\(escapedStreet)"

        BaseNetworkService().performRequest(streetNameURLString)
        {
            response, error in
            if let json = response {
                var streetsNames: [Street] = [Street]()
                if let streets = json.array {
                    for street in streets {
                        streetsNames.append(Street(json: street))
                    }
                }
                completionHandler(streetsNames, nil)
            } else {
                print("\nError: \(error!.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    }

    public func getAddressFromCoordinate(latitude: Double, longitude: Double, completionHandler: (JSON?, NSError?) -> ())
    {
        print("You tapped at: \(latitude), \(longitude)")
        let addressFromCoordinateURLString = "\(coordinateToAddressEndpointURL)&latitud=\(latitude)&longitud=\(longitude)"

        BaseNetworkService().performRequest(addressFromCoordinateURLString, completionHandler: completionHandler)
    }
}
