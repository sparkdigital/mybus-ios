//
//  BusRouteResult.swift
//  MyBus
//
//  Created by Lisandro Falconi on 4/25/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import SwiftyJSON

class BusRouteResult: NSObject {
    var busRouteType: Int
    var busRoutes: [BusRoute] = [BusRoute]()
    var combinationDistance: Double = 0.0 //Only used when type is 1
    var routeRoad: MapBusRoad?

    init(type: Int)
    {
        self.busRouteType = type
    }

    // MARK: Parse search results
    static func parseResults(results: JSON, type: Int) -> [BusRouteResult]
    {
        var listBusRouteResult: [BusRouteResult] = [BusRouteResult]()

        if let routes = results.array
        {
            switch type
            {
            case 0:
                for route in routes
                {
                    let busRoute: BusRouteResult = parseSingleRoute(route)
                    listBusRouteResult.append(busRoute)
                }
                return listBusRouteResult
            case 1:
                for route in routes
                {
                    let busRoute: BusRouteResult = parseCombinedRoute(route)
                    listBusRouteResult.append(busRoute)
                }
                return listBusRouteResult
            default:
                return listBusRouteResult
            }

        }
        return listBusRouteResult
    }

    // MARK: Parse route
    /**
        Parse result of a single route
     */
    static func parseSingleRoute(route: JSON) -> BusRouteResult
    {
        let busRouteResult: BusRouteResult = BusRouteResult(type: 0)
        var busRoute: BusRoute = BusRoute()

        busRoute = setBusLineInfo(route, busRoute: busRoute, isCombinated: false, isFirstLine: false)
        busRoute = setStartBusStopInfo(route, busRoute: busRoute, isCombinated: false, isFirstLine: false)
        busRoute = setDestinationBusStopInfo(route, busRoute: busRoute, isCombinated: false, isFirstLine: false)

        busRouteResult.busRoutes.append(busRoute)

        return busRouteResult

    }

    /**
        Parse result of a combinated route to arrive destination
     */
    static func parseCombinedRoute(route: JSON) -> BusRouteResult
    {
        let busRouteResult: BusRouteResult = BusRouteResult(type: 1)
        var firstBusRoute: BusRoute = BusRoute()

        firstBusRoute = setBusLineInfo(route, busRoute: firstBusRoute, isCombinated: true, isFirstLine: true)
        firstBusRoute = setStartBusStopInfo(route, busRoute: firstBusRoute, isCombinated: true, isFirstLine: true)
        firstBusRoute = setDestinationBusStopInfo(route, busRoute: firstBusRoute, isCombinated: true, isFirstLine: true)

        busRouteResult.busRoutes.append(firstBusRoute)

        var secondBusRoute: BusRoute = BusRoute()

        secondBusRoute = setBusLineInfo(route, busRoute: secondBusRoute, isCombinated: true, isFirstLine: false)
        secondBusRoute = setStartBusStopInfo(route, busRoute: secondBusRoute, isCombinated: true, isFirstLine: false)
        secondBusRoute = setDestinationBusStopInfo(route, busRoute: secondBusRoute, isCombinated: true, isFirstLine: false)

        busRouteResult.busRoutes.append(secondBusRoute)

        busRouteResult.combinationDistance = route["CombinationDistance"].doubleValue

        return busRouteResult
    }


    // MARK: Set bus route info
    /**
        Set bus related information in a BusRoute
    */
    static func setBusLineInfo(lineInfo: JSON, busRoute: BusRoute, isCombinated: Bool, isFirstLine: Bool) -> BusRoute
    {
        var path: String = ""
        if isCombinated
        {
            path = isFirstLine ? "First" : "Second"
        }

        busRoute.idBusLine = lineInfo["Id\(path)BusLine"].intValue
        busRoute.busLineName = lineInfo["\(path)BusLineName"].stringValue
        busRoute.busLineDirection = lineInfo["\(path)BusLineDirection"].intValue
        busRoute.busLineColor = lineInfo["\(path)BusLineColor"].stringValue
        return busRoute
    }

    /**
        Set stop information of bus to start itineray
     */
    static func setStartBusStopInfo(startBusStop: JSON, busRoute: BusRoute, isCombinated: Bool, isFirstLine: Bool) -> BusRoute
    {
        var path: String = ""
        if isCombinated
        {
            path = isFirstLine ? "FirstLine" : "SecondLine"
        }
        busRoute.startBusStopNumber = startBusStop["\(path)StartBusStopNumber"].intValue
        busRoute.startBusStopLat = startBusStop["\(path)StartBusStopLat"].stringValue
        busRoute.startBusStopLng = startBusStop["\(path)StartBusStopLng"].stringValue
        busRoute.startBusStopStreetName = startBusStop["\(path)StartBusStopStreetName"].stringValue
        busRoute.startBusStopStreetNumber = startBusStop["\(path)StartBusStopStreetNumber"].intValue
        busRoute.startBusStopDistanceToOrigin = startBusStop["\(path)StartBusStopDistanceToOrigin"].doubleValue
        return busRoute
    }

    /**
        Set stop information of bus to descent and continue to destination
     */
    static func setDestinationBusStopInfo(destinationBusStop: JSON, busRoute: BusRoute, isCombinated: Bool, isFirstLine: Bool) -> BusRoute
    {
        var path: String = ""
        if isCombinated
        {
            path = isFirstLine ? "FirstLine" : "SecondLine"
        }
        busRoute.destinationBusStopNumber = destinationBusStop["\(path)DestinationBusStopNumber"].intValue
        busRoute.destinationBusStopLat = destinationBusStop["\(path)DestinationBusStopLat"].stringValue
        busRoute.destinationBusStopLng = destinationBusStop["\(path)DestinatioBusStopLng"].stringValue
        busRoute.destinationBusStopStreetName = destinationBusStop["\(path)DestinatioBusStopStreetName"].stringValue
        busRoute.destinationBusStopStreetNumber = destinationBusStop["\(path)DestinatioBusStopStreetNumber"].intValue
        busRoute.destinationBusStopDistanceToDestination = destinationBusStop["\(path)DestinatioBusStopDistanceToDestination"].doubleValue
        return busRoute
    }

    func getRouteRoad(completionHandler: (MapBusRoad?, NSError?)->()) -> Void {
        if (self.routeRoad != nil) {
            completionHandler(self.routeRoad, nil)
        } else {
            let busRouteType: MyBusRouteResultType = self.busRouteType == 0 ? MyBusRouteResultType.Single : MyBusRouteResultType.Combined
            switch busRouteType {
            case .Single:
                Connectivity.sharedInstance.getSingleResultRoadApi((self.busRoutes.first?.idBusLine)!, firstDirection: (self.busRoutes.first?.busLineDirection)!, beginStopFirstLine: (self.busRoutes.first?.startBusStopNumber)!, endStopFirstLine: (self.busRoutes.first?.destinationBusStopNumber)!) {
                    singleRoad, error in

                    if let road = singleRoad
                    {
                        self.routeRoad = MapBusRoad().addBusRoadOnMap(road)
                        completionHandler(self.routeRoad, error)
                    } else {
                        completionHandler(nil, error)
                    }
                }
            case .Combined:
                let firstBusRoute = self.busRoutes.first
                let secondBusRoute = self.busRoutes.last
                Connectivity.sharedInstance.getCombinedResultRoadApi((firstBusRoute?.idBusLine)!, idSecondLine: (secondBusRoute?.idBusLine)!, firstDirection: (firstBusRoute?.busLineDirection)!, secondDirection: (secondBusRoute?.busLineDirection)!, beginStopFirstLine: (firstBusRoute?.startBusStopNumber)!, endStopFirstLine: (firstBusRoute?.destinationBusStopNumber)!, beginStopSecondLine: (secondBusRoute?.startBusStopNumber)!, endStopSecondLine: (secondBusRoute?.destinationBusStopNumber)!) {
                    combinedRoad, error in
                    if let road = combinedRoad
                    {
                        self.routeRoad = MapBusRoad().addBusRoadOnMap(road)
                        completionHandler(self.routeRoad, error)
                    } else {
                        completionHandler(nil, error)
                    }

                }
            }
        }
    }
}
