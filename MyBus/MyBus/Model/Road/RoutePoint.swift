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

    static func parseFromGeoGoogle(geoPointJson: JSON) -> RoutePoint? {
        let geoPoint = RoutePoint()
        let firstResultJson = geoPointJson["results"][0]
        let isAddress = firstResultJson["address_components"][0]["types"] == [ "street_number" ]
        let jsonStatus = firstResultJson["status"].stringValue

        guard isAddress else {
            return nil
        }

        switch jsonStatus {
        case "OK":
            let originLocation = firstResultJson["geometry"]["location"]
            let streetName = firstResultJson["address_components"][1]["short_name"].stringValue
            let streetNumber = firstResultJson["address_components"][0]["short_name"].stringValue

            geoPoint.latitude = originLocation["lat"].stringValue
            geoPoint.longitude = originLocation["lng"].stringValue
            geoPoint.address = "\(streetName) \(streetNumber)"

            return geoPoint
        default:
            return nil
        }


    }

    func getLatLng() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
    }
}
