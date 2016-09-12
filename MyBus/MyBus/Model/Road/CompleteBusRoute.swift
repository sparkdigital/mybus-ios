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
        //TODO humanize this ""business logic""
        var markers: [MGLPointAnnotation] = []

        if let startGoingPoint = goingPointList.first, let endGoingPoint = goingPointList.last {

            //### IDA ###
            //Create START point marker of GOING route
            let startGoingMarker = self.markerCreator(startGoingPoint.getLatLong(), title: nil, subtitle: startGoingPoint.address)

            if let endReturnPoint = returnPointList.last, let startReturnPoint = returnPointList.first {
                //### VUELTA ###
                //Create START point marker of RETURN route
                let startReturnMarker = self.markerCreator(startReturnPoint.getLatLong(), title: nil, subtitle: startReturnPoint.address)

                if self.isEqualStartGoingEndReturn() {
                    startGoingMarker.title = "\(MyBusTitle.SameStartEndCompleteBusRoute.rawValue) \(busLineName)"
                } else {
                    startGoingMarker.title = "\(MyBusTitle.StartCompleteBusRoute.rawValue) \(busLineName)"
                    startReturnMarker.title = "\(MyBusTitle.StartCompleteBusRoute.rawValue) \(busLineName)"

                    //Create END point marker of RETURN route
                    let endReturnMarker = self.markerCreator(endReturnPoint.getLatLong(), title: "\(MyBusTitle.EndCompleteBusRoute.rawValue) \(busLineName)", subtitle: endReturnPoint.address)
                    markers.append(endReturnMarker)
                }

                //Check if start of return route is the same of last for going route -> use a different icon
                if self.isEqualStartReturnEndGoing() {
                    //Start and end points are the same place
                    startReturnMarker.title = "\(MyBusTitle.SameStartEndCompleteBusRoute.rawValue) \(busLineName)"
                } else {
                    startReturnMarker.title = "\(MyBusTitle.StartCompleteBusRoute.rawValue) \(busLineName)"

                    //Create END point marker of GOING route
                    let endGoingMarker = self.markerCreator(endGoingPoint.getLatLong(), title: "\(MyBusTitle.EndCompleteBusRoute.rawValue) \(busLineName)", subtitle: endGoingPoint.address)
                    markers.append(endGoingMarker)
                }
                markers.append(startReturnMarker)

            } else {
                //We don't have return route yet
                startGoingMarker.title = "\(MyBusTitle.StartCompleteBusRoute.rawValue) \(busLineName)"

                //Create END point marker of GOING route
                let endGoingMarker = self.markerCreator(endGoingPoint.getLatLong(), title: "\(MyBusTitle.EndCompleteBusRoute.rawValue) \(busLineName)", subtitle: endGoingPoint.address)
                markers.append(endGoingMarker)
            }
            markers.append(startGoingMarker)
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

    func markerCreator(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) -> MGLPointAnnotation {
        let markerCreated = MGLPointAnnotation()
        markerCreated.coordinate = coordinate
        if let titleText = title {
            markerCreated.title = titleText
        }
        if let subtitleText = subtitle {
            markerCreated.subtitle = subtitleText
        }
        return markerCreated
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
