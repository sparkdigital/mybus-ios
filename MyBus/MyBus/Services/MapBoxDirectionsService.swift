//
//  MapBoxDirectionsService.swift
//  MyBus
//
//  Created by Lisandro Falconi on 5/28/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import MapboxDirections

protocol MapBoxDirectionsDelegate {
    func getWalkingDirections(_ sourceCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D, completionHandler: @escaping (MapboxDirections.Route?, NSError?) -> ())
}

private let mapboxAccessToken = Configuration.mapBoxAPIKey()

open class MapBoxDirectionsService: NSObject, MapBoxDirectionsDelegate {

    internal func getWalkingDirections(_ sourceCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D, completionHandler: @escaping (MapboxDirections.Route?, NSError?) -> ())
    {
        let directions = Directions(accessToken: mapboxAccessToken)
        let options = RouteOptions(coordinates: [sourceCoordinate, destinationCoordinate], profileIdentifier: MBDirectionsProfileIdentifierWalking)
        options.includesSteps = true

        _ = directions.calculate(options) { (waypoints, routes, error) in
            completionHandler(routes?.first, error)
        }
    }
}
