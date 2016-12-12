//
//  SearchManager.swift
//  MyBus
//
//  Created by Lisandro Falconi on 8/16/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import Mapbox
import RealmSwift

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

    /**
     This method gets the busses using two Address.

     @param origin address of origin point.

     @destination address of origin destination.
     */
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
                self.getBusLines((originPoint?.getLatLong())!, destination: (destinationPoint?.getLatLong())!, completionHandler: {
                    (busRouteResult, error) in

                    if let result = busRouteResult {
                        
                        print("Origin: \(originPoint)| Destination: \(destinationPoint) | BusRoutes: \(result)")
                        
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
     This method gets the busses using two coordinates.

     @param origin coordinate of origin point.

     @destination coordinate of origin destination.
     */
    func search(origin: RoutePoint, destination: RoutePoint, completionHandler: (BusSearchResult?, NSError?) -> ()) -> Void {
        self.getBusLines(origin.getLatLong(), destination: destination.getLatLong(), completionHandler: {
            (busRouteResult, error) in
            if let result = busRouteResult {
                
                print("Origin: \(origin)| Destination: \(destination) | BusRoutes: \(result)")
                
                self.currentSearch = BusSearchResult(origin: origin, destination: destination, busRoutes: result)
                completionHandler(self.currentSearch, nil)
            } else {
                completionHandler(nil, error)
            }
        })
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
            let busRouteType: MyBusRouteResultType = busRouteResult.busRouteType
            switch busRouteType {
            case .Single:
                Connectivity.sharedInstance.getSingleResultRoadApi((busRouteResult.busRoutes.first?.idBusLine)!, firstDirection: (busRouteResult.busRoutes.first?.busLineDirection)!, beginStopFirstLine: (busRouteResult.busRoutes.first?.startBusStopNumber)!, endStopFirstLine: (busRouteResult.busRoutes.first?.destinationBusStopNumber)!) {
                    singleRoadResult, error in

                    if let roadResult = singleRoadResult {
                        roadResult.idBusLine1 = String((busRouteResult.busRoutes.first?.idBusLine)!)
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
        let startLocation = self.currentSearch?.origin.getLatLong()
        let endLocation = self.currentSearch?.destination.getLatLong()

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

    func getCompleteRoute(idBusLine: Int, busLineName: String, completion: (CompleteBusRoute?, NSError?)->()) -> Void {
        let connectivtyResultsCompletionHandler: (CompleteBusRoute?, NSError?) -> Void = { (justGoingBusRoute, error) in
            if let completeRoute = justGoingBusRoute {
                //Get route in return way
                Connectivity.sharedInstance.getCompleteRoads(idBusLine, direction: 1, completionHandler: { (returnBusRoute, error) in
                    completeRoute.busLineName = busLineName
                    if let fullCompleteRoute = returnBusRoute {
                        //Another hack
                        completeRoute.returnPointList = fullCompleteRoute.goingPointList

                        //Save in device storage using Realm
                        DBManager.sharedInstance.updateCompleteBusItinerary(completeRoute)
                        return completion(completeRoute, error)
                    } else {
                        return completion(completeRoute, error)
                    }
                })
            } else {
                return completion(nil, error)
            }
        }

        let busItineraryResult = DBManager.sharedInstance.findOneCompleteBusItinerary(busLineName)
        if let busItinerary = busItineraryResult {
            let secondsInADay: NSTimeInterval = 3600 * 30
            let secondsSavedSinceNow = abs(busItinerary.savedDate.timeIntervalSinceNow)


            if secondsSavedSinceNow > secondsInADay  {
                //Sync itineraries each one month
                Connectivity.sharedInstance.getCompleteRoads(idBusLine, direction: 0, completionHandler: connectivtyResultsCompletionHandler)
            } else {
                let route = CompleteBusRoute()
                route.busLineName = busItinerary.busLineName
                route.goingPointList = Array(busItinerary.goingItineraryPoint)
                route.returnPointList = Array(busItinerary.returnItineraryPoint)

                completion(route, nil)
            }

        } else {
            //Get route in going way of bus line
            Connectivity.sharedInstance.getCompleteRoads(idBusLine, direction: 0, completionHandler: connectivtyResultsCompletionHandler)
        }

    }

}
