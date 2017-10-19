//
//  GeoCodingService.swift
//  MyBus
//
//  Created by Lisandro Falconi on 5/28/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol GeoCodingServiceDelegate {
    func getCoordinateFromAddress(_ streetName: String, completionHandler: @escaping (RoutePoint?, Error?) -> ())
}

open class GeoCodingService: NSObject, GeoCodingServiceDelegate {
    internal func getCoordinateFromAddress(_ streetName: String, completionHandler: @escaping (RoutePoint?, Error?) -> ()) {
        print("Address to resolve geocoding: \(streetName)")

        let address = "\(streetName), mar del plata"
        let components = "political:Buenos%20Aires|political:General%20Pueyrredón%20Partido|political:Mar%20del%20Plata"

        do {
            let request: URLRequest =  try GeoCodingRouter.coordinateFromAddressComponents(address: address, components: components, key: GeoCodingRouter.GEO_CODING_API_KEY).asURLRequest()

            BaseNetworkService.performRequest(request) { response, error in
                if let json = response {
                    completionHandler(RoutePoint.parseFromGeoGoogle(json), error)
                } else {
                    completionHandler(nil, error)
                }
            }
        } catch {
            NSLog("Failed building coordinate from address URL request")
        }
    }
}
