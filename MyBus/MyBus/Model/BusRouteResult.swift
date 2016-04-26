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
    
    func parseResults(results : JSON, type : Int) -> [BusRouteResult]
    {
        var listBusRouteResult : [BusRouteResult] = [BusRouteResult]()
        
        if let routes = results.array {
            if(type == 0)
            {
                for route in routes {
                    let busRoute : BusRouteResult = parseSingleRoute(route)
                    listBusRouteResult.append(busRoute)
                }
                return listBusRouteResult
            } else if (type == 1)
            {
                for route in routes {
                    let busRoute : BusRouteResult = parseCombinedRoute(route)
                    listBusRouteResult.append(busRoute)
                }
                return listBusRouteResult
            }
        }
        return listBusRouteResult
    }
    
    func parseSingleRoute(route : JSON) -> BusRouteResult
    {
//        if (route == null) {
//            return null;
//        } TODO

        let busRouteResult : BusRouteResult = BusRouteResult(type: 0)
        var busRoute : BusRoute = BusRoute()
        
        busRoute.mIdBusLine = route["IdBusLine"].intValue
        busRoute.mBusLineName = route["BusLineName"].stringValue
        busRoute.mBusLineDirection = route["BusLineDirection"].intValue
        busRoute.mBusLineColor = route["BusLineColor"].stringValue
        
        busRoute.mStartBusStopNumber = route["StartBusStopNumber"].intValue
        busRoute.mStartBusStopLat = route["StartBusStopLat"].stringValue
        busRoute.mStartBusStopLng = route["StartBusStopLng"].stringValue
        busRoute.mStartBusStopStreetName = route["StartBusStopStreetName"].stringValue
        busRoute.mStartBusStopStreetNumber = route["StartBusStopStreetNumber"].intValue
        busRoute.mStartBusStopDistanceToOrigin = route["StartBusStopDistanceToOrigin"].doubleValue
        
        busRoute.mDestinationBusStopNumber = route["DestinationBusStopNumber"].intValue
        busRoute.mDestinationBusStopLat = route["DestinationBusStopLat"].stringValue
        busRoute.mDestinationBusStopLng = route["DestinatioBusStopLng"].stringValue
        busRoute.mDestinationBusStopStreetName = route["DestinatioBusStopStreetName"].stringValue
        busRoute.mDestinationBusStopStreetNumber = route["DestinatioBusStopStreetNumber"].intValue
        busRoute.mDestinationBusStopDistanceToDestination = route["DestinatioBusStopDistanceToDestination"].doubleValue
        
        busRouteResult.mBusRoutes.append(busRoute)
        
        return busRouteResult
    }
    
    func parseCombinedRoute(route : JSON) -> BusRouteResult
    {
        //        if (route == null) {
        //            return null;
        //        } TODO
        
        let busRouteResult : BusRouteResult = BusRouteResult(type: 1)
        var firstBusRoute : BusRoute = BusRoute()
        
        firstBusRoute.mIdBusLine = route["IdBusLine"].intValue
        firstBusRoute.mBusLineName = route["BusLineName"].stringValue
        firstBusRoute.mBusLineDirection = route["BusLineDirection"].intValue
        firstBusRoute.mBusLineColor = route["BusLineColor"].stringValue
        
        firstBusRoute.mStartBusStopNumber = route["StartBusStopNumber"].intValue
        firstBusRoute.mStartBusStopLat = route["StartBusStopLat"].stringValue
        firstBusRoute.mStartBusStopLng = route["StartBusStopLng"].stringValue
        firstBusRoute.mStartBusStopStreetName = route["StartBusStopStreetName"].stringValue
        firstBusRoute.mStartBusStopStreetNumber = route["StartBusStopStreetNumber"].intValue
        firstBusRoute.mStartBusStopDistanceToOrigin = route["StartBusStopDistanceToOrigin"].doubleValue
        
        firstBusRoute.mDestinationBusStopNumber = route["DestinationBusStopNumber"].intValue
        firstBusRoute.mDestinationBusStopLat = route["DestinationBusStopLat"].stringValue
        firstBusRoute.mDestinationBusStopLng = route["DestinatioBusStopLng"].stringValue
        firstBusRoute.mDestinationBusStopStreetName = route["DestinatioBusStopStreetName"].stringValue
        firstBusRoute.mDestinationBusStopStreetNumber = route["DestinatioBusStopStreetNumber"].intValue
        firstBusRoute.mDestinationBusStopDistanceToDestination = route["DestinatioBusStopDistanceToDestination"].doubleValue
        
        busRouteResult.mBusRoutes.append(firstBusRoute)
        
        var secondBusRoute : BusRoute = BusRoute()
        
        secondBusRoute.mIdBusLine = route["IdBusLine"].intValue
        secondBusRoute.mBusLineName = route["BusLineName"].stringValue
        secondBusRoute.mBusLineDirection = route["BusLineDirection"].intValue
        secondBusRoute.mBusLineColor = route["BusLineColor"].stringValue
        
        secondBusRoute.mStartBusStopNumber = route["StartBusStopNumber"].intValue
        secondBusRoute.mStartBusStopLat = route["StartBusStopLat"].stringValue
        secondBusRoute.mStartBusStopLng = route["StartBusStopLng"].stringValue
        secondBusRoute.mStartBusStopStreetName = route["StartBusStopStreetName"].stringValue
        secondBusRoute.mStartBusStopStreetNumber = route["StartBusStopStreetNumber"].intValue
        secondBusRoute.mStartBusStopDistanceToOrigin = route["StartBusStopDistanceToOrigin"].doubleValue
        
        secondBusRoute.mDestinationBusStopNumber = route["DestinationBusStopNumber"].intValue
        secondBusRoute.mDestinationBusStopLat = route["DestinationBusStopLat"].stringValue
        secondBusRoute.mDestinationBusStopLng = route["DestinatioBusStopLng"].stringValue
        secondBusRoute.mDestinationBusStopStreetName = route["DestinatioBusStopStreetName"].stringValue
        secondBusRoute.mDestinationBusStopStreetNumber = route["DestinatioBusStopStreetNumber"].intValue
        secondBusRoute.mDestinationBusStopDistanceToDestination = route["DestinatioBusStopDistanceToDestination"].doubleValue

        busRouteResult.mBusRoutes.append(secondBusRoute)
        
        busRouteResult.mCombinationDistance = route["CombinationDistance"].doubleValue
    
        return busRouteResult
    }
    
    
}