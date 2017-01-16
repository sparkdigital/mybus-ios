//
//  BusRouteResult.swift
//  MyBus
//
//  Created by Lisandro Falconi on 4/25/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import SwiftyJSON

open class BusRouteResult: NSObject {
    var busRouteType: MyBusRouteResultType
    var busRoutes: [BusRoute] = [BusRoute]()
    var combinationDistance: Double = 0.0 //Only used when type is 1

    init(type: MyBusRouteResultType)
    {
        self.busRouteType = type
    }

    // MARK: Parse search results
    static func parseResults(_ results: JSON, type: Int) -> [BusRouteResult]
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
    static func parseSingleRoute(_ route: JSON) -> BusRouteResult
    {
        let busRouteResult: BusRouteResult = BusRouteResult(type: MyBusRouteResultType.single)
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
    static func parseCombinedRoute(_ route: JSON) -> BusRouteResult
    {
        let busRouteResult: BusRouteResult = BusRouteResult(type: MyBusRouteResultType.combined)
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
    static func setBusLineInfo(_ lineInfo: JSON, busRoute: BusRoute, isCombinated: Bool, isFirstLine: Bool) -> BusRoute
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
    static func setStartBusStopInfo(_ startBusStop: JSON, busRoute: BusRoute, isCombinated: Bool, isFirstLine: Bool) -> BusRoute
    {
        if isCombinated
        {
            if isFirstLine {
                busRoute.startBusStopNumber = startBusStop["FirstLineStartBusStopNumber"].intValue
                busRoute.startBusStopLat = startBusStop["FirstLineStartBusStopLat"].stringValue
                busRoute.startBusStopLng = startBusStop["FirstLineStartBusStopLng"].stringValue
                busRoute.startBusStopStreetName = startBusStop["FirstLineStartBusStopStreet"].stringValue
                busRoute.startBusStopStreetNumber = startBusStop["FirstLineStartBusStopStreetNumber"].intValue
                busRoute.startBusStopDistanceToOrigin = startBusStop["FirstLineStartBusStopDistance"].doubleValue
                return busRoute
            } else {
                busRoute.startBusStopNumber = startBusStop["SecondLineStartBusStopNumber"].intValue
                busRoute.startBusStopLat = startBusStop["SecondLineStartBusStopLat"].stringValue
                busRoute.startBusStopLng = startBusStop["SecondLineStartBusStopLng"].stringValue
                busRoute.startBusStopStreetName = startBusStop["SecondLineStartBusStopStreet"].stringValue
                busRoute.startBusStopStreetNumber = startBusStop["SecondLineStartBusStopStreetNumber"].intValue
                busRoute.startBusStopDistanceToOrigin = startBusStop["SecondLineDestinationBusStopDistance"].doubleValue
                return busRoute
            }
        }
        busRoute.startBusStopNumber = startBusStop["StartBusStopNumber"].intValue
        busRoute.startBusStopLat = startBusStop["StartBusStopLat"].stringValue
        busRoute.startBusStopLng = startBusStop["StartBusStopLng"].stringValue
        busRoute.startBusStopStreetName = startBusStop["StartBusStopStreetName"].stringValue
        busRoute.startBusStopStreetNumber = startBusStop["StartBusStopStreetNumber"].intValue
        busRoute.startBusStopDistanceToOrigin = startBusStop["StartBusStopDistanceToOrigin"].doubleValue
        return busRoute
    }

    /**
        Set stop information of bus to descent and continue to destination
     */
    static func setDestinationBusStopInfo(_ destinationBusStop: JSON, busRoute: BusRoute, isCombinated: Bool, isFirstLine: Bool) -> BusRoute
    {
        if isCombinated
        {
            if isFirstLine {
                busRoute.destinationBusStopNumber = destinationBusStop["FirstLineDestinationBusStopNumber"].intValue
                busRoute.destinationBusStopLat = destinationBusStop["FirstLineDestinatioBusStopLat"].stringValue
                busRoute.destinationBusStopLng = destinationBusStop["FirstLineDestinatioBusStopLng"].stringValue
                busRoute.destinationBusStopStreetName = destinationBusStop["FirstLineDestinatioBusStopStreet"].stringValue
                busRoute.destinationBusStopStreetNumber = destinationBusStop["FirstLineDestinatioBusStopStreetNumber"].intValue
                return busRoute

            } else {
                busRoute.destinationBusStopNumber = destinationBusStop["SecondLineDestinationBusStopNumber"].intValue
                busRoute.destinationBusStopLat = destinationBusStop["SecondLineDestinationBusStopLat"].stringValue
                busRoute.destinationBusStopLng = destinationBusStop["SecondLineDestinationBusStopLng"].stringValue
                busRoute.destinationBusStopStreetName = destinationBusStop["SecondLineDestinationBusStopStreet"].stringValue
                busRoute.destinationBusStopStreetNumber = destinationBusStop["SecondLineDestinationBusStopStreetNumber"].intValue
                busRoute.destinationBusStopDistanceToDestination = destinationBusStop["SecondLineDestinationBusStopDistance"].doubleValue
                return busRoute
            }
        }
        busRoute.destinationBusStopNumber = destinationBusStop["DestinationBusStopNumber"].intValue
        busRoute.destinationBusStopLat = destinationBusStop["DestinationBusStopLat"].stringValue
        busRoute.destinationBusStopLng = destinationBusStop["DestinatioBusStopLng"].stringValue
        busRoute.destinationBusStopStreetName = destinationBusStop["DestinatioBusStopStreetName"].stringValue
        busRoute.destinationBusStopStreetNumber = destinationBusStop["DestinatioBusStopStreetNumber"].intValue
        busRoute.destinationBusStopDistanceToDestination = destinationBusStop["DestinatioBusStopDistanceToDestination"].doubleValue
        return busRoute
    }
}
