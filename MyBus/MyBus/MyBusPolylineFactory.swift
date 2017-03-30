//
//  MyBusPolylineFactory.swift
//  MyBus
//
//  Created by Lisandro Falconi on 10/6/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import Mapbox
import MapboxDirections

class MyBusPolylineFactory {

    class func buildWalkingRoutePolylineList(_ roadResult: RoadResult)-> [MyBusPolyline]{
        let walkingRoutes = roadResult.walkingRoutes
        return walkingRoutes.map { (route) -> MyBusPolyline in
            var stepsCoordinates: [CLLocationCoordinate2D] = route.coordinates!
            return MyBusWalkingPolyline(coordinates: &stepsCoordinates, count: UInt(stepsCoordinates.count))
        }
    }

    class func createBusRoutePolyline(_ busRoute: Route, busLineId: String) -> MyBusPolyline {
        var busRouteCoordinates: [CLLocationCoordinate2D] = busRoute.pointList.map { (point: RoutePoint) -> CLLocationCoordinate2D in
            return point.getLatLong()
        }
        let busPolyline = MyBusRoadResultPolyline(coordinates: &busRouteCoordinates, count: UInt(busRouteCoordinates.count))
        busPolyline.busLineIdentifier = busLineId
        return busPolyline
    }

    class func buildBusRoutePolylineList(_ roadResult: RoadResult)-> [MyBusPolyline] {

        var busRoutePolylineList: [MyBusPolyline] = []

        // First bus route polyline
        guard let firstBusRoute: Route = roadResult.routeList.first else {
            return busRoutePolylineList
        }

        let firstBusLine = MyBusPolylineFactory.createBusRoutePolyline(firstBusRoute, busLineId: roadResult.idBusLine1)
        busRoutePolylineList.append(firstBusLine)

        // If road is combinated, we add second bus route polyline
        if roadResult.busRouteResultType() == .combined
        {
            let secondBusRoute = roadResult.routeList[1]
            let secondBusLine = MyBusPolylineFactory.createBusRoutePolyline(secondBusRoute, busLineId: roadResult.idBusLine2)
            busRoutePolylineList.append(secondBusLine)
        }

        return busRoutePolylineList
    }

    class func buildCompleteBusRoutePolylineList(_ completeBusRoute: CompleteBusRoute) -> [MyBusPolyline] {
        let goingPointList = completeBusRoute.goingPointList
        let returnPointList = completeBusRoute.returnPointList

        // List include going, return or both polylines
        var roadLists: [MyBusPolyline] = []

        //Going route
        var busRouteCoordinates: [CLLocationCoordinate2D] = []
        if goingPointList.count > 0 {
            busRouteCoordinates = goingPointList.map({ (point: RoutePoint) -> CLLocationCoordinate2D in
                return point.getLatLong()
            })
            let busPolylineGoing = MyBusGoingCompleteBusRoutePolyline(coordinates: &busRouteCoordinates, count: UInt(busRouteCoordinates.count))
            roadLists.append(busPolylineGoing)

        }
        //Return route
        if returnPointList.count > 0 {
            busRouteCoordinates = []
            busRouteCoordinates = returnPointList.map({ (point: RoutePoint) -> CLLocationCoordinate2D in
                return point.getLatLong()
            })
            let busPolylineReturn = MyBusReturnCompleteBusRoutePolyline(coordinates: &busRouteCoordinates, count: UInt(busRouteCoordinates.count))
            roadLists.append(busPolylineReturn)
        }

        return roadLists
    }
}
