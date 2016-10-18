//
//  MyBusMapModel.swift
//  MyBus
//
//  Created by Sebastian Fink on 10/14/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation

class MyBusMapModel {
    
    var originMarker:MyBusMarkerOriginPoint?
    var destinationMarker:MyBusMarkerDestinationPoint?
    var currentRoad:(roadMarkers:MyBusMarker,roadPolyline:MyBusRoadResultPolyline,walkingPath:MyBusWalkingPolyline)?
    var rechargePointList:[MyBusMarkerRechargePoint]?
    var completeBusRoute:(markers:MyBusMarkerCompleteRoutePoint,polyline:MyBusPolyline)?
    
    
    init(){
        
    }
    
    func clearModel(){
    }
    
    func updateOrigin(newOrigin:RoutePoint){}
    func updateDestination(newDestination:RoutePoint){}
    func updateRoad(){}
    func toggleRechargePoints(points:[RechargePoint]){}
    func updateCompleteBusRoute(){}
    
}