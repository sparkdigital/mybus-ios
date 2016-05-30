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
    var roadResultType: Int = 0
    var totalDistances: Double = 0.0
    var travelTime: Int = 0
    var arrivalTime: Int = 0
    var routeList: [Route] = [Route]()
    var idBusLine1: String = ""
    var idBusLine2: String = ""

    static func parse(roadResultResponse: JSON) -> RoadResult
    {
        let singleRoad = RoadResult()

        if let type = roadResultResponse["Type"].int
        {
            singleRoad.roadResultType = type
            singleRoad.totalDistances = roadResultResponse["TotalDistance"].doubleValue
            singleRoad.travelTime = roadResultResponse["TravelTime"].intValue
            singleRoad.arrivalTime = roadResultResponse["ArrivalTime"].intValue
            singleRoad.totalDistances = roadResultResponse["TotalDistance"].doubleValue
            let route = Route.parse(roadResultResponse["Route1"].array!)
            singleRoad.routeList.append(route)

            if let routeTwo = roadResultResponse["Route2"].array
            {
                let route = Route.parse(routeTwo)
                singleRoad.routeList.append(route)
                singleRoad.idBusLine1 = roadResultResponse["IdBusLine1"].stringValue
                singleRoad.idBusLine2 = roadResultResponse["IdBusLine2"].stringValue
            }
        }
        return singleRoad
    }

    /**
        Return a list of point reference that form a result road route
     */
    func getPointList() -> [RoutePoint]
    {
        var pointsInRoute = [RoutePoint]()
        guard !routeList.isEmpty else {
            return pointsInRoute
        }

        for route in routeList
        {
            pointsInRoute.appendContentsOf(route.pointList)
        }
        return pointsInRoute
    }

    func busRouteResultType() -> MyBusRouteResultType {
        return self.roadResultType == 0 ? .Single : .Combined
    }
}
