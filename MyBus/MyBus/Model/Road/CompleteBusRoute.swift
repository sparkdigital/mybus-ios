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
            completeBusRoute.goingPointList = results.map({ (point: JSON) -> RoutePoint in
                RoutePoint.parse(point)
            })
        }
        return completeBusRoute
    }

    func getMarkersAnnotation() -> [MGLPointAnnotation] {
        var markers: [MGLPointAnnotation] = []
        let sameStartEndTitle = "\(MyBusTitle.SameStartEndCompleteBusRoute.rawValue) \(busLineName)"
        let startTitle = "\(MyBusTitle.StartCompleteBusRoute.rawValue) \(busLineName)"
        let endTitle = "\(MyBusTitle.EndCompleteBusRoute.rawValue) \(busLineName)"

        if let startGoingPoint = goingPointList.first, let endGoingPoint = goingPointList.last {
            if let startReturnPoint = returnPointList.first, let endReturnPoint = returnPointList.last {
                //Here we have both routes loaded

                // Is the start point of going route equals end of return? Use a different icon
                let isEqualStartGoingEndReturn = self.isEqualStartGoingEndReturn()
                // Is the start point of return route equals end of going? Use a different icon
                let isEqualStartReturnEndGoing = self.isEqualStartReturnEndGoing()

                if isEqualStartGoingEndReturn {
                    let startGoingEndReturnMarker = self.markerCreator(startGoingPoint, title: sameStartEndTitle)
                    markers.append(startGoingEndReturnMarker)
                } else {
                    let startGoingMarker = self.markerCreator(startGoingPoint, title: startTitle)
                    markers.append(startGoingMarker)

                    //Add END of RETURN route
                    let endReturnMarker = self.markerCreator(endReturnPoint, title: endTitle)
                    markers.append(endReturnMarker)
                }

                if isEqualStartReturnEndGoing {
                    let startReturnEndGoingMarker = self.markerCreator(startReturnPoint, title: sameStartEndTitle)
                    markers.append(startReturnEndGoingMarker)
                } else {
                    let startReturnMarker = self.markerCreator(startReturnPoint, title: startTitle)
                    markers.append(startReturnMarker)

                    //Add END of GOING route
                    let endGoingMarker = self.markerCreator(endGoingPoint, title: endTitle)
                    markers.append(endGoingMarker)
                }

            } else {
                //Here we just have going route
                let startGoingMarker = self.markerCreator(startGoingPoint, title: startTitle)
                let endGoingMarker = self.markerCreator(endGoingPoint, title: endTitle)
                markers.append(startGoingMarker)
                markers.append(endGoingMarker)
            }
        }
        return markers
    }

    func getPolyLines() -> [MGLPolyline] {
        // List include going, return or both polylines
        var roadLists: [MGLPolyline] = []

        //Going route
        var busRouteCoordinates: [CLLocationCoordinate2D] = []
        if goingPointList.count > 0 {
            busRouteCoordinates = goingPointList.map({ (point: RoutePoint) -> CLLocationCoordinate2D in
                return CLLocationCoordinate2DMake(Double(point.latitude)!, Double(point.longitude)!)
            })
            let busPolylineGoing = MGLPolyline(coordinates: &busRouteCoordinates, count: UInt(busRouteCoordinates.count))
            busPolylineGoing.title = "Going"
            roadLists.append(busPolylineGoing)

        }
        //Return route
        if returnPointList.count > 0 {
            busRouteCoordinates = []
            busRouteCoordinates = returnPointList.map({ (point: RoutePoint) -> CLLocationCoordinate2D in
                return CLLocationCoordinate2DMake(Double(point.latitude)!, Double(point.longitude)!)
            })
            let busPolylineReturn = MGLPolyline(coordinates: &busRouteCoordinates, count: UInt(busRouteCoordinates.count))
            busPolylineReturn.title = "Return"
            roadLists.append(busPolylineReturn)
        }

        return roadLists
    }

    func markerCreator(point: RoutePoint, title: String?) -> MGLPointAnnotation {
        let markerCreated = MGLPointAnnotation()
        markerCreated.coordinate = point.getLatLong()
        if let titleText = title {
            markerCreated.title = titleText
        }
        markerCreated.subtitle = point.address

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
