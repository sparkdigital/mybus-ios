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

class CompleteBusRoute {
    var busLineName: String = ""
    var goingPointList: [RoutePoint] = []
    var returnPointList: [RoutePoint] = []

    func parseOneWayBusRoute(json: JSON, busLineName: String) -> CompleteBusRoute {
        let completeBusRoute = CompleteBusRoute()
        completeBusRoute.busLineName = busLineName

        if let results = json["Results"].array {
            var points: [RoutePoint] = []
            for point in results {
                points.append(RoutePoint.parse(point))
            }
            completeBusRoute.goingPointList = points
        }
        return completeBusRoute
    }

    func getMarkersAnnotation() -> [MGLPointAnnotation] {
        var markers: [MGLPointAnnotation] = []

        if let startGoing = goingPointList.first {
            let startGoingMarker = MGLPointAnnotation()
            startGoingMarker.coordinate = startGoing.getLatLong()
            startGoingMarker.subtitle = startGoing.address

            if let lastReturn = returnPointList.last {

                //Check if start of going route is the same of last for return route -> use a different icon
                if startGoing.latitude == lastReturn.latitude && startGoing.longitude == lastReturn.longitude {
                    //Start and end points are the same place
                    startGoingMarker.title = "Inicio y fin \(busLineName)"
                } else {
                    //Start of going route is different end of return route
                    startGoingMarker.title = "Inicio \(busLineName)"

                    let startReturnMarker = MGLPointAnnotation()
                    startReturnMarker.coordinate = lastReturn.getLatLong()
                    startReturnMarker.subtitle = lastReturn.address
                    startReturnMarker.title = "Inicio \(busLineName)"

                    let endReturnMarker = MGLPointAnnotation()
                    endReturnMarker.coordinate = returnPointList.first!.getLatLong()
                    endReturnMarker.subtitle = returnPointList.first!.address
                    endReturnMarker.title = "Fin \(busLineName)"

                    markers.append(startReturnMarker)
                    markers.append(endReturnMarker)
                }
            } else {
                //We don't have return route yet
                startGoingMarker.title = "Inicio \(busLineName)"
            }
            markers.append(startGoingMarker)

            let endGoingMarker = MGLPointAnnotation()
            endGoingMarker.coordinate = goingPointList.last!.getLatLong()
            endGoingMarker.subtitle = goingPointList.last!.address
            endGoingMarker.title = "Fin \(busLineName)"
            markers.append(endGoingMarker)
        }

        return markers
    }

    func getPolyLines() -> [MGLPolyline] {
        // List include going, return or both polylines
        var roadLists: [MGLPolyline] = []

        //Going route
        var busRouteCoordinates: [CLLocationCoordinate2D] = []
        if goingPointList.count > 0 {
            for point in goingPointList {
                let coordinate = CLLocationCoordinate2DMake(Double(point.latitude)!, Double(point.longitude)!)
                busRouteCoordinates.append(coordinate)
            }
            let busPolylineGoing = MGLPolyline(coordinates: &busRouteCoordinates, count: UInt(busRouteCoordinates.count))
            busPolylineGoing.title = "Going"
            roadLists.append(busPolylineGoing)

        }
        //Return route
        if returnPointList.count > 0 {
            busRouteCoordinates = []
            for point in returnPointList {
                let coordinate = CLLocationCoordinate2DMake(Double(point.latitude)!, Double(point.longitude)!)
                busRouteCoordinates.append(coordinate)
            }
            let busPolylineReturn = MGLPolyline(coordinates: &busRouteCoordinates, count: UInt(busRouteCoordinates.count))
            busPolylineReturn.title = "Return"
            roadLists.append(busPolylineReturn)
        }

        return roadLists
    }
}
