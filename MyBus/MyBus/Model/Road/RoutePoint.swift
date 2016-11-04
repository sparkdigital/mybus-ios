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
import RealmSwift

class RoutePoint: Object {
    dynamic var stopId: String = " "
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var address: String = " "
    dynamic var isWaypoint: Bool = false
    dynamic var name: String = ""

    static func parse(routePointJson: JSON) -> RoutePoint
    {
        let point = RoutePoint()
        if let stopId = routePointJson["StopId"].string
        {
            point.stopId = stopId
            point.latitude = routePointJson["Lat"].doubleValue
            point.longitude = routePointJson["Lng"].doubleValue
            point.address = routePointJson["Address"].stringValue
            point.isWaypoint = routePointJson["isWaypoint"].boolValue

            return point
        } else {
            return point
        }
    }

    static func parse(latitude: Double, longitude: Double) -> RoutePoint
    {
        let point = RoutePoint()
        point.latitude = latitude
        point.longitude = longitude
        point.address = ""
        return point
    }

    static func parseFromGeoGoogle(geoPointJson: JSON) -> RoutePoint? {
        let validTypes = ["street_address", "intersection", "natural_feature", "airport", "park", "point_of_interest", "establishment", "bus_station"]
        let successCode: String = "OK"
        let geoPoint = RoutePoint()
        let firstResultJson = geoPointJson["results"][0]
        let setValidTypes = Set(validTypes)
        let responseTypes = firstResultJson["types"].arrayObject as! [String]
        let isValid = !(setValidTypes.intersect(responseTypes).isEmpty)

        let jsonStatus = geoPointJson["status"].stringValue

        guard isValid else {
            return nil
        }

        switch jsonStatus {
        case successCode:
            let originLocation = firstResultJson["geometry"]["location"]

            var address = firstResultJson["formatted_address"].stringValue.componentsSeparatedByString(",").first
            address = address?.stringByReplacingOccurrencesOfString("&", withString: "Y")

            geoPoint.latitude = originLocation["lat"].doubleValue
            geoPoint.longitude = originLocation["lng"].doubleValue
            geoPoint.address = address ?? "Ubicación sin nombre"

            return geoPoint
        default:
            return nil
        }
    }

    func getLatLong() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
