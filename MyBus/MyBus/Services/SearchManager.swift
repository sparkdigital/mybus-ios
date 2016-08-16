//
//  SearchManager.swift
//  MyBus
//
//  Created by Lisandro Falconi on 8/16/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import Mapbox

private let _sharedInstance = SearchManager()

public class SearchManager: NSObject {
    var currentSearch: BusSearchResult?

    // MARK: - Instantiation
    public class var sharedInstance: SearchManager {
        return _sharedInstance
    }

    override init() { }

    func getBusLines(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> [BusRouteResult]?
    {
        Connectivity.sharedInstance.getBusLinesFromOriginDestination(origin.latitude, longitudeOrigin: origin.longitude, latitudeDestination: destination.latitude, longitudeDestination: destination.longitude) {
            busRouteResults, error in

            guard (error != nil) else {
                return nil
            }
            return busRouteResults
        }
    }

    func search(origin: String, destination: String, callback: (BusSearchResult, NSError?)) -> Void {
        Connectivity.sharedInstance.getCoordinateFromAddress(origin) {
            originPoint, error in

            guard (originPoint != nil) else {
                //TODO: Notify
            }
            Connectivity.sharedInstance.getCoordinateFromAddress(destination) {
                destinationPoint, error in

                guard (destinationPoint != nil) else {
                    //TODO: Notify
                }
                let busRouteResults: [BusRouteResult] = self.getBusLines((originPoint?.getLatLng())!, destination: (destinationPoint?.getLatLng())!)!
                self.currentSearch = BusSearchResult(origin: originPoint!, destination: destinationPoint!, busRoutes: busRouteResults)
                //TODO: Notify
            }
        }
    }

}
