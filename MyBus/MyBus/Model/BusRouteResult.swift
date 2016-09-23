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

    init(type: Int)
    {
        self.busRouteType = type
    }

    // MARK: Parse search results
    static func parseResults(results: JSON, type: Int) -> [BusRouteResult]
    {
        let listBusRouteResult: [BusRouteResult] = [BusRouteResult]()

        if let routes = results.array
        {
            switch type
            {
            case 0:
                return routes.map({ (route: JSON) -> BusRouteResult in
                    return parseSingleRoute(route)
                })
                
            case 1:
                return routes.map({ (route: JSON) -> BusRouteResult in
                    return parseCombinedRoute(route)
                })
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
}
