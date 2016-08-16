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
    var busRouteOptions: [BusRouteResult]

    init(origin: RoutePoint, destination: RoutePoint, busRoutes: [BusRouteResult]?)
    {
        self.origin = origin
        self.destination = destination
        self.busRouteOptions = busRoutes!
    }

//    func resolveWalkingPath(origin: RoutePoint, destination: RoutePoint) -> [MBRoute] {
//        var walkingPaths: [MBRoute] = []
//        //TODO resolve walking directions
//        return walkingPaths
//    }
}
