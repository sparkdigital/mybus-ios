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
    @objc dynamic var stopId: String = " "
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var address: String = " "
    @objc dynamic var isWaypoint: Bool = false
    @objc dynamic var name: String = ""

    static func parse(_ routePointJson: JSON) -> RoutePoint
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

    static func parse(_ latitude: Double, longitude: Double) -> RoutePoint
    {
        let point = RoutePoint()
        point.latitude = latitude
        point.longitude = longitude
        point.address = ""
        return point
    }

    static func parseFromGeoGoogle(_ geoPointJson: JSON) -> RoutePoint? {
        let validTypes = ["street_address", "intersection", "natural_feature", "airport", "park", "point_of_interest", "establishment", "bus_station", "route", "store"]
        let successCode: String = "OK"
        let geoPoint = RoutePoint()
        let firstResultJson = geoPointJson["results"][0]
        let setValidTypes = Set(validTypes)
        let responseTypes = Set(firstResultJson["types"].arrayValue.map({$0.stringValue}))
        let isValid = !(setValidTypes.intersection(responseTypes).isEmpty)

        let jsonStatus = geoPointJson["status"].stringValue

        guard isValid else {
            return nil
        }

        switch jsonStatus {
        case successCode:
            let originLocation = firstResultJson["geometry"]["location"]

            // To prevent geocoded places from having a misformatted address starting for example with zip code
            let addresses = firstResultJson["formatted_address"].stringValue.components(separatedBy: ",").filter({ (value) -> Bool in
                do {
                    let digitRegEx = try NSRegularExpression(pattern: "^B760\\d", options: [])
                    let addressComponent = value as NSString
                    let results = digitRegEx.matches(in: addressComponent as String, options: [], range: NSMakeRange(0, addressComponent.length))
                    return value.count > 1 && results.count == 0
                }
                catch {
                    return value.count > 1
                }
            })
            var address = addresses.first
            address = address?.replacingOccurrences(of: "&", with: "Y")
            address = address?.trimmingCharacters(in: .whitespacesAndNewlines)
            geoPoint.latitude = originLocation["lat"].doubleValue
            geoPoint.longitude = originLocation["lng"].doubleValue
            geoPoint.address = address ?? "Ubicación sin nombre"
            geoPoint.address = geoPoint.address.components(separatedBy: "-").first ?? geoPoint.address
            return geoPoint
        default:
            return nil
        }
    }

    func getLatLong() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
