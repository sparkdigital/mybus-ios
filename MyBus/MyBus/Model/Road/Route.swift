//
//  Route.swift
//  MyBus
//
//  Created by Lisandro Falconi on 4/25/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import SwiftyJSON
import Mapbox

class Route: NSObject {
    var pointList : [RoutePoint] = [RoutePoint]()

    static func parse(routeJson : [JSON]) -> Route
    {
        let route = Route()
        var points : [RoutePoint] = [RoutePoint]()
        for routePoint in routeJson
        {
            let point = RoutePoint.parse(routePoint)
            points.append(point)
        }
        route.pointList = points
        return route
    }

    func getFirstLatLng() -> CLLocationCoordinate2D {
        return (pointList.first?.getLatLng())!;
    }

    func getLastLatLng() -> CLLocationCoordinate2D {
        return (pointList.last?.getLatLng())!
    }
}
