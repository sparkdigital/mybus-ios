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

    func getBusLines(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completionHandler: ([BusRouteResult]?, NSError?) -> ()) -> Void {
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

                    if let result = busRouteResult {
                        self.currentSearch = BusSearchResult(origin: originPoint!, destination: destinationPoint!, busRoutes: result)
                        completionHandler(self.currentSearch, nil)
                    } else {
                        completionHandler(nil, error)
                    }
                })
            }
        }
    }

    /**
     Look for RoadResult for a BusRouteResult
     We check in currentSearch if we Road was resolved before, if not we resolve and return RoadResult

     First method will ask API for RoadResult either Single or Combined then add walking directions

     :returns: Completion callback with an optional RoadResult and NSError?
     */
    func getRoad(busRouteResult: BusRouteResult, completionHandler: (RoadResult?, NSError?)->()) -> Void {
        if let roadResult = self.currentSearch?.roads(busRouteResult) {
            completionHandler(roadResult, nil)
        } else {
            let busRouteType: MyBusRouteResultType = busRouteResult.busRouteType == 0 ? MyBusRouteResultType.Single : MyBusRouteResultType.Combined
            switch busRouteType {
            case .Single:
                Connectivity.sharedInstance.getSingleResultRoadApi((busRouteResult.busRoutes.first?.idBusLine)!, firstDirection: (busRouteResult.busRoutes.first?.busLineDirection)!, beginStopFirstLine: (busRouteResult.busRoutes.first?.startBusStopNumber)!, endStopFirstLine: (busRouteResult.busRoutes.first?.destinationBusStopNumber)!) {
                    singleRoadResult, error in

                    if let roadResult = singleRoadResult {
                        let busRouteKey = self.currentSearch?.getStringBusResultRow(busRouteResult)

                        self.getWalkingRoutes(roadResult, completion: {
                            self.currentSearch?.addRoad(busRouteKey!, roadResult: roadResult)
                            completionHandler(roadResult, error)
                        })
                    } else {
                        completionHandler(nil, error)
                    }
                }
            case .Combined:
                let firstBusRoute = busRouteResult.busRoutes.first
                let secondBusRoute = busRouteResult.busRoutes.last
                Connectivity.sharedInstance.getCombinedResultRoadApi((firstBusRoute?.idBusLine)!, idSecondLine: (secondBusRoute?.idBusLine)!, firstDirection: (firstBusRoute?.busLineDirection)!, secondDirection: (secondBusRoute?.busLineDirection)!, beginStopFirstLine: (firstBusRoute?.startBusStopNumber)!, endStopFirstLine: (firstBusRoute?.destinationBusStopNumber)!, beginStopSecondLine: (secondBusRoute?.startBusStopNumber)!, endStopSecondLine: (secondBusRoute?.destinationBusStopNumber)!) {
                    combinedRoadResult, error in
                    if let roadResult = combinedRoadResult {
                        let busRouteKey = self.currentSearch?.getStringBusResultRow(busRouteResult)

                        self.getWalkingRoutes(roadResult, completion: {
                            self.currentSearch?.addRoad(busRouteKey!, roadResult: roadResult)
                            completionHandler(roadResult, error)
                        })
                    } else {
                        completionHandler(nil, error)
                    }
                }
            }
        }
    }

    /**
     Resolve walking directions involved in a RoadResult

     First we check and resolve walking directions between start location to first bus start stop
     When we have a combined result we resolve walking route between first bus end stop and second bus start stop
     Then we resolve the last part of Road, between last bus end stop to endLocation

     :returns: Completion callback emtpy
     */
    func getWalkingRoutes(roadResult: RoadResult, completion: ()->()) -> Void {
        let startLocation = self.currentSearch?.origin.getLatLng()
        let endLocation = self.currentSearch?.destination.getLatLng()

        if let start = startLocation, let firstBusStop = roadResult.firstBusStop {
            roadResult.addWalkingDirection(start, to: firstBusStop, completion: {
                if let midStartBusStop = roadResult.midStartStop, let midEndBusStop = roadResult.midEndStop {
                    roadResult.addWalkingDirection(midStartBusStop, to: midEndBusStop, completion: {
                        if let end = endLocation, let endBusStop = roadResult.endBusStop {
                            roadResult.addWalkingDirection(end, to: endBusStop, completion: {
                                completion()
                            })
                        }
                    })
                }
                if let end = endLocation, let endBusStop = roadResult.endBusStop {
                    roadResult.addWalkingDirection(end, to: endBusStop, completion: {
                        completion()
                    })
                }
            })
        }
    }

}
