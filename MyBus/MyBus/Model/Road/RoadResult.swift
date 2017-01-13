//
//  RoadResult.swift
//  MyBus
//
//  Created by Lisandro Falconi on 4/25/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import SwiftyJSON
import MapboxDirections
import MapKit

class RoadResult: NSObject {
    var roadResultType: Int = 0
    var totalDistances: Double = 0.0
    var travelTime: Int = 0
    var arrivalTime: Int = 0
    var routeList: [Route] = []
    var walkingRoutes: [MapboxDirections.Route] = []
    var idBusLine1: String = ""
    var idBusLine2: String = ""
    //Single
    var firstBusStop: CLLocationCoordinate2D?
    var endBusStop: CLLocationCoordinate2D?
    //Combined
    var midStartStop: CLLocationCoordinate2D?
    var midEndStop: CLLocationCoordinate2D?

    static func parse(_ roadResultResponse: JSON) -> RoadResult {
        let singleRoad = RoadResult()

        if let type = roadResultResponse["Type"].int {
            singleRoad.roadResultType = type
            singleRoad.totalDistances = roadResultResponse["TotalDistance"].doubleValue
            singleRoad.travelTime = roadResultResponse["TravelTime"].intValue
            singleRoad.arrivalTime = roadResultResponse["ArrivalTime"].intValue
            let route = Route.parse(roadResultResponse["Route1"].array!)

            singleRoad.firstBusStop = route.getFirstLatLng()
            singleRoad.endBusStop = route.getLastLatLng()

            singleRoad.routeList.append(route)

            if let routeTwo = roadResultResponse["Route2"].array {
                singleRoad.midStartStop = route.getLastLatLng()

                let route = Route.parse(routeTwo)

                singleRoad.midEndStop = route.getFirstLatLng()
                singleRoad.endBusStop = route.getLastLatLng()
                singleRoad.routeList.append(route)
                singleRoad.idBusLine1 = roadResultResponse["IdBusLine1"].stringValue
                singleRoad.idBusLine2 = roadResultResponse["IdBusLine2"].stringValue
            }
        }
        return singleRoad
    }

    /**
        Return a list of point reference that form a result road route
     */
    func getPointList() -> [RoutePoint] {
        var pointsInRoute = [RoutePoint]()
        guard !routeList.isEmpty else {
            return pointsInRoute
        }

        for route in routeList {
            pointsInRoute.append(contentsOf: route.pointList)
        }
        return pointsInRoute
    }

    func busRouteResultType() -> MyBusRouteResultType {
        return self.roadResultType == 0 ? .single : .combined
    }

    /**
     Resolve and add user walking directions as part of RoadResult

     :returns: Completion callback empty
     */
    func addWalkingDirection(_ from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, completion: @escaping ()->()) -> Void {
        Connectivity.sharedInstance.getWalkingDirections(from, destinationCoordinate: to) {
            response, error in
            print(error ?? "")
            if let walkRoute = response {
                if walkRoute.distance > CLLocationDistance(100) {
                    self.walkingRoutes.append(walkRoute)
                    completion()
                } else {
                    completion()
                }
            } else {
                completion()
            }
        }
    }
    
    func formattedTravelDistance()->String{
        return "\(String(format: "%.1f", self.totalDistances)) Km"
    }
    
    func formattedTravelTime()->String {
        return "\(self.travelTime) min"
    }
    
    func formattedWalkingDistance(_ walkRouteDistance:Double) -> String {
        let distanceInBlocks = Int(round(walkRouteDistance / 100))
        let suffix = distanceInBlocks == 1 ? "cuadra" : "cuadras"
        return "\(distanceInBlocks) \(suffix)"
    }
    
}
