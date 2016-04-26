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
    var mType : Int
    var mBusRoutes : [BusRoute] = [BusRoute]()
    var mCombinationDistance : Double = 0.0 //Only used when type is 1
    
    init(type : Int)
    {
        self.mType = type
    }
    
    // MARK: Parse search results
    func parseResults(results : JSON, type : Int) -> [BusRouteResult]
    {
        var listBusRouteResult : [BusRouteResult] = [BusRouteResult]()
        
        if let routes = results.array {
            switch type {
            case 0:
                for route in routes {
                    let busRoute : BusRouteResult = parseSingleRoute(route)
                    listBusRouteResult.append(busRoute)
                }
                return listBusRouteResult
            case 1:
                for route in routes {
                    let busRoute : BusRouteResult = parseCombinedRoute(route)
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
    func parseSingleRoute(route : JSON) -> BusRouteResult
    {
        let busRouteResult : BusRouteResult = BusRouteResult(type: 0)
        var busRoute : BusRoute = BusRoute()
        
        busRoute = setBusLineInfo(route, busRoute: busRoute, isCombinated: false, isFirstLine: false)
        busRoute = setStartBusStopInfo(route, busRoute: busRoute, isCombinated: false, isFirstLine: false)
        busRoute = setDestinationBusStopInfo(route, busRoute: busRoute, isCombinated: false, isFirstLine: false)
        
        busRouteResult.mBusRoutes.append(busRoute)
        
        return busRouteResult
        
    }
    
    func parseCombinedRoute(route : JSON) -> BusRouteResult
    {
        let busRouteResult : BusRouteResult = BusRouteResult(type: 1)
        var firstBusRoute : BusRoute = BusRoute()
        
        firstBusRoute = setBusLineInfo(route, busRoute: firstBusRoute, isCombinated: true, isFirstLine: true)
        firstBusRoute = setStartBusStopInfo(route, busRoute: firstBusRoute, isCombinated: true, isFirstLine: true)
        firstBusRoute = setDestinationBusStopInfo(route, busRoute: firstBusRoute, isCombinated: true, isFirstLine: true)

        busRouteResult.mBusRoutes.append(firstBusRoute)
        
        var secondBusRoute : BusRoute = BusRoute()
        
        secondBusRoute = setBusLineInfo(route, busRoute: secondBusRoute, isCombinated: true, isFirstLine: false)
        secondBusRoute = setStartBusStopInfo(route, busRoute: secondBusRoute, isCombinated: true, isFirstLine: false)
        secondBusRoute = setDestinationBusStopInfo(route, busRoute: secondBusRoute, isCombinated: true, isFirstLine: false)

        busRouteResult.mBusRoutes.append(secondBusRoute)
        
        busRouteResult.mCombinationDistance = route["CombinationDistance"].doubleValue
    
        return busRouteResult
    }
    
    
    // MARK: Set bus route info
    func setBusLineInfo(lineInfo : JSON, busRoute : BusRoute, isCombinated : Bool, isFirstLine : Bool) -> BusRoute {
        var path : String = ""
        if(isCombinated)
        {
            path = isFirstLine ? "First" : "Second"
        }
        
        busRoute.mIdBusLine = lineInfo["Id\(path)BusLine"].intValue
        busRoute.mBusLineName = lineInfo["\(path)BusLineName"].stringValue
        busRoute.mBusLineDirection = lineInfo["\(path)BusLineDirection"].intValue
        busRoute.mBusLineColor = lineInfo["\(path)BusLineColor"].stringValue
        return busRoute
    }
    
    func setStartBusStopInfo(startBusStop : JSON, busRoute : BusRoute, isCombinated : Bool, isFirstLine : Bool) -> BusRoute {
        var path : String = ""
        if(isCombinated)
        {
            path = isFirstLine ? "FirstLine" : "SecondLine"
        }
        busRoute.mStartBusStopNumber = startBusStop["\(path)StartBusStopNumber"].intValue
        busRoute.mStartBusStopLat = startBusStop["\(path)StartBusStopLat"].stringValue
        busRoute.mStartBusStopLng = startBusStop["\(path)StartBusStopLng"].stringValue
        busRoute.mStartBusStopStreetName = startBusStop["\(path)StartBusStopStreetName"].stringValue
        busRoute.mStartBusStopStreetNumber = startBusStop["\(path)StartBusStopStreetNumber"].intValue
        busRoute.mStartBusStopDistanceToOrigin = startBusStop["\(path)StartBusStopDistanceToOrigin"].doubleValue
        return busRoute
    }
    
    func setDestinationBusStopInfo(destinationBusStop : JSON, busRoute : BusRoute, isCombinated : Bool, isFirstLine : Bool) -> BusRoute {
        var path : String = ""
        if(isCombinated)
        {
            path = isFirstLine ? "FirstLine" : "SecondLine"
        }
        busRoute.mDestinationBusStopNumber = destinationBusStop["\(path)DestinationBusStopNumber"].intValue
        busRoute.mDestinationBusStopLat = destinationBusStop["\(path)DestinationBusStopLat"].stringValue
        busRoute.mDestinationBusStopLng = destinationBusStop["\(path)DestinatioBusStopLng"].stringValue
        busRoute.mDestinationBusStopStreetName = destinationBusStop["\(path)DestinatioBusStopStreetName"].stringValue
        busRoute.mDestinationBusStopStreetNumber = destinationBusStop["\(path)DestinatioBusStopStreetNumber"].intValue
        busRoute.mDestinationBusStopDistanceToDestination = destinationBusStop["\(path)DestinatioBusStopDistanceToDestination"].doubleValue
        return busRoute
    }
    
}