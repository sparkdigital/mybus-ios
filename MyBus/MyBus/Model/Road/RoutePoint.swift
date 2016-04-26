//
//  RoutePoint.swift
//  MyBus
//
//  Created by Lisandro Falconi on 4/25/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import SwiftyJSON

class RoutePoint: NSObject {
    var mStopId : String = " "
    var mLat : String = " "
    var mLng : String = " "
    var mAddress : String = " "
    var isWaypoint : Bool = false
    
    static func parse(routePointJson : JSON) -> RoutePoint
    {
        let point = RoutePoint()
        if let stopId = routePointJson["StopId"].string
        {
            point.mStopId = stopId
            point.mLat = routePointJson["Lat"].stringValue
            point.mLng = routePointJson["Lng"].stringValue
            point.mAddress = routePointJson["Address"].stringValue
            point.isWaypoint = routePointJson["StopId"].boolValue
            
            return point
        } else {
            return point
        }
    }
}