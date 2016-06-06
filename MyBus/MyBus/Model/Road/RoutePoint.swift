//
//  RoutePoint.swift
//  MyBus
//
//  Created by Lisandro Falconi on 4/25/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import SwiftyJSON
import Mapbox

class RoutePoint: NSObject {
    var stopId: String = " "
    var latitude: String = " "
    var longitude: String = " "
    var address: String = " "
    var isWaypoint: Bool = false

    static func parse(routePointJson: JSON) -> RoutePoint
    {
        let point = RoutePoint()
        if let stopId = routePointJson["StopId"].string
        {
            point.stopId = stopId
            point.latitude = routePointJson["Lat"].stringValue
            point.longitude = routePointJson["Lng"].stringValue
            point.address = routePointJson["Address"].stringValue
            point.isWaypoint = routePointJson["StopId"].boolValue

            return point
        } else {
            return point
        }
    }

    func getLatLng() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
    }
}
