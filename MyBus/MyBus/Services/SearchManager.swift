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

    func getBusLines(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completionHandler: ([BusRouteResult]?, NSError?) -> ()) -> Void
    {
        Connectivity.sharedInstance.getBusLinesFromOriginDestination(origin.latitude, longitudeOrigin: origin.longitude, latitudeDestination: destination.latitude, longitudeDestination: destination.longitude) {
            busRouteResults, error in

            if let buses = busRouteResults {
                return completionHandler(buses, nil)
            } else {
                return completionHandler(nil, error)
            }
        }
    }

    func search(origin: String, destination: String, completionHandler: (BusSearchResult?, NSError?) -> ()) -> Void {
        Connectivity.sharedInstance.getCoordinateFromAddress(origin) {
            originPoint, error in

            guard (originPoint != nil) else {
                return completionHandler(nil, NSError(domain:"OriginGeocoding", code:2, userInfo:nil))
            }
            Connectivity.sharedInstance.getCoordinateFromAddress(destination) {
                destinationPoint, error in

                guard (destinationPoint != nil) else {
                    return completionHandler(nil, NSError(domain:"DestinationGeocoding", code:2, userInfo:nil))
                }
                self.getBusLines((originPoint?.getLatLng())!, destination: (destinationPoint?.getLatLng())!, completionHandler: {
                    (busRouteResult, error) in

                    if let result = busRouteResult
                    {
                        self.currentSearch = BusSearchResult(origin: originPoint!, destination: destinationPoint!, busRoutes: result)
                        completionHandler(self.currentSearch, nil)
                    } else {
                        completionHandler(nil, error)
                    }
                })
            }
        }
    }

    func getRoad(busRouteResult: BusRouteResult, completionHandler: (RoadResult?, NSError?)->()) -> Void {
        if let roadResult = self.currentSearch?.roads(busRouteResult) {
            completionHandler(roadResult, nil)
        } else {
            let busRouteType: MyBusRouteResultType = busRouteResult.busRouteType == 0 ? MyBusRouteResultType.Single : MyBusRouteResultType.Combined
            switch busRouteType {
            case .Single:
                Connectivity.sharedInstance.getSingleResultRoadApi((busRouteResult.busRoutes.first?.idBusLine)!, firstDirection: (busRouteResult.busRoutes.first?.busLineDirection)!, beginStopFirstLine: (busRouteResult.busRoutes.first?.startBusStopNumber)!, endStopFirstLine: (busRouteResult.busRoutes.first?.destinationBusStopNumber)!) {
                    singleRoad, error in

                    if let road = singleRoad
                    {
                        let busRouteKey = self.currentSearch?.getStringBusResultRow(busRouteResult)
                        self.currentSearch?.addRoad(busRouteKey!, roadResult: road)
                        completionHandler(road, error)
                    } else {
                        completionHandler(nil, error)
                    }
                }
            case .Combined:
                let firstBusRoute = busRouteResult.busRoutes.first
                let secondBusRoute = busRouteResult.busRoutes.last
                Connectivity.sharedInstance.getCombinedResultRoadApi((firstBusRoute?.idBusLine)!, idSecondLine: (secondBusRoute?.idBusLine)!, firstDirection: (firstBusRoute?.busLineDirection)!, secondDirection: (secondBusRoute?.busLineDirection)!, beginStopFirstLine: (firstBusRoute?.startBusStopNumber)!, endStopFirstLine: (firstBusRoute?.destinationBusStopNumber)!, beginStopSecondLine: (secondBusRoute?.startBusStopNumber)!, endStopSecondLine: (secondBusRoute?.destinationBusStopNumber)!) {
                    combinedRoad, error in
                    if let road = combinedRoad
                    {
                        let busRouteKey = self.currentSearch?.getStringBusResultRow(busRouteResult)
                        self.currentSearch?.addRoad(busRouteKey!, roadResult: road)
                        completionHandler(road, error)
                    } else {
                        completionHandler(nil, error)
                    }
                }
            }
        }
    }

}
