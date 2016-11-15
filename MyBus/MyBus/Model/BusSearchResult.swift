//
//  BusSearchResult.swift
//  MyBus
//
//  Created by Lisandro Falconi on 8/11/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation

class BusSearchResult
{
    var origin: RoutePoint
    var destination: RoutePoint
    var busRouteOptions: [BusRouteResult] = [BusRouteResult]()
    var indexSelected: Int?
    var road: [String: RoadResult] = [String: RoadResult]()

    var hasRouteOptions: Bool {
        return busRouteOptions.count > 0
    }

    init(origin: RoutePoint, destination: RoutePoint, busRoutes: [BusRouteResult]?)
    {
        self.origin = origin
        self.destination = destination
        if let busOptions = busRoutes {
            self.busRouteOptions = busOptions
        }
    }


    /**
    Look for RoadResult for a BusRouteResult
     First of all we get key for BusRouteResult then if RoadResult was saved we return it
     In case RoadResult has not been saved before we return nil

     :returns: RoadResult for a BusRouteResult or nil
    */
    func roads(busRouteResult: BusRouteResult) -> RoadResult? {
        let busRouteKey = self.getStringBusResultRow(busRouteResult)
        if let roadResult = road[busRouteKey] {
            return roadResult
        } else {
            return nil
        }
    }

    /**
     Add RoadResult for a BusRouteResult key
     */
    func addRoad(key: String, roadResult: RoadResult) -> Void {
        road.updateValue(roadResult, forKey: key)
    }
}
