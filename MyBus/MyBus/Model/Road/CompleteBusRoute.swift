//
//  CompleteBusRoute.swift
//  MyBus
//
//  Created by Lisandro Falconi on 9/7/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import SwiftyJSON
import Mapbox

public class CompleteBusRoute {
    var busLineName: String = ""
    var goingPointList: [RoutePoint] = []
    var returnPointList: [RoutePoint] = []

    func parseOneWayBusRoute(json: JSON, busLineName: String) -> CompleteBusRoute {
        let completeBusRoute = CompleteBusRoute()
        completeBusRoute.busLineName = busLineName

        if let results = json["Results"].array {
            completeBusRoute.goingPointList = results.map({ (point: JSON) -> RoutePoint in
                RoutePoint.parse(point)
            })
        }
        return completeBusRoute
    }

    func isEqualStartGoingEndReturn() -> Bool {
        if let startGoingPoint = goingPointList.first, let endReturnPoint = returnPointList.last {
            if startGoingPoint.latitude == endReturnPoint.latitude && startGoingPoint.longitude == endReturnPoint.longitude {
                return true
            }
        }
        return false
    }

    func isEqualStartReturnEndGoing() -> Bool {
        if let startReturnPoint = returnPointList.first, let endGoingPoint = goingPointList.last {
            if startReturnPoint.latitude == endGoingPoint.latitude && startReturnPoint.longitude == endGoingPoint.longitude {
                return true
            }
        }
        return false
    }
}
