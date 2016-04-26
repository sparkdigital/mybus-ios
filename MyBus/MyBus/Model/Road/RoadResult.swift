//
//  RoadResult.swift
//  MyBus
//
//  Created by Lisandro Falconi on 4/25/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import SwiftyJSON

class RoadResult: NSObject {
    var mType : Int = 0
    var mTotalDistances : Double = 0.0
    var mTravelTime : Int = 0
    var mArrivalTime : Int = 0
    var mRouteList : [Route] = [Route]()
    var mIdBusLine1 : String = ""
    var mIdBusLine2 : String = ""
    
    func parse(roadResultResponse : JSON) -> RoadResult
    {
        let singleRoad = RoadResult()
        
        if let type = roadResultResponse["Type"].int
        {
            singleRoad.mType = type
            singleRoad.mTotalDistances = roadResultResponse["TotalDistance"].doubleValue
            singleRoad.mTravelTime = roadResultResponse["TravelTime"].intValue
            singleRoad.mArrivalTime = roadResultResponse["ArrivalTime"].intValue
            singleRoad.mTotalDistances = roadResultResponse["TotalDistance"].doubleValue
            let route = Route.parse(roadResultResponse["Route1"].array!)
            singleRoad.mRouteList.append(route)
            
            if let routeTwo = roadResultResponse["Route2"].array
            {
                let route = Route.parse(routeTwo)
                singleRoad.mRouteList.append(route)
                singleRoad.mIdBusLine1 = roadResultResponse["IdBusLine1"].stringValue
                singleRoad.mIdBusLine2 = roadResultResponse["IdBusLine2"].stringValue
            }
        }
        return singleRoad
    }
    
    func getPointList() -> [RoutePoint]
    {
        var pointsInRoute = [RoutePoint]()
        if(!mRouteList.isEmpty)
        {
            for route in mRouteList
            {
                pointsInRoute.appendContentsOf(route.mPointList)
            }
            return pointsInRoute
        } else
        {
            return pointsInRoute
        }
    }
}