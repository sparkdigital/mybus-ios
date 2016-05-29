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
    func getWalkingDirections(sourceCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D, completionHandler: (MBDirectionsResponse?, NSError?) -> ())
}

private let mapboxAccessToken = "pk.eyJ1Ijoibm9zb3VsODgiLCJhIjoiY2lteGt2dHhsMDNrNXZxbHU0M29mcHZnZiJ9.MMbmK9GfcdhpDw2siu0wuA"

public class MapBoxDirectionsService: NSObject, MapBoxDirectionsDelegate {

    func getWalkingDirections(sourceCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D, completionHandler: (MBDirectionsResponse?, NSError?) -> ())
    {
        let walkingToDestinationDirectionsRequest = MBDirectionsRequest(sourceCoordinate: sourceCoordinate, destinationCoordinate: destinationCoordinate)
        walkingToDestinationDirectionsRequest.transportType = .Walking

        let destinationDirections = MBDirections(request: walkingToDestinationDirectionsRequest, accessToken: mapboxAccessToken)
        destinationDirections.calculateDirectionsWithCompletionHandler {
            response, error in
            completionHandler(response, error)
        }

    }

}
