//
//  BusRoute.swift
//  MyBus
//
//  Created by Lisandro Falconi on 4/25/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation

class BusRoute : NSObject {
    var idBusLine : Int? = 0
    var busLineName : String? = " "
    var busLineDirection : Int? = 0
    var busLineColor : String? = " "
    var startBusStopNumber : Int? = 0
    var startBusStopLat : String? = " "
    var startBusStopLng : String? = " "
    var startBusStopStreetName : String? = " "
    var startBusStopStreetNumber : Int? = 0
    var startBusStopDistanceToOrigin : Double?
    var destinationBusStopNumber : Int? = 0
    var destinationBusStopLat : String? = " "
    var destinationBusStopLng : String? = " "
    var destinationBusStopStreetName : String? = " "
    var destinationBusStopStreetNumber : Int? = 0
    var destinationBusStopDistanceToDestination : Double? = 0.0

}
