//
//  BusRoute.swift
//  MyBus
//
//  Created by Lisandro Falconi on 4/25/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation

struct BusRoute {
    var mIdBusLine : Int?
    var mBusLineName : String?
    var mBusLineDirection : Int?
    var mBusLineColor : String?
    var mStartBusStopNumber : Int?
    var mStartBusStopLat : String?
    var mStartBusStopLng : String?
    var mStartBusStopStreetName : String?
    var mStartBusStopStreetNumber : Int?
    var mStartBusStopDistanceToOrigin : Double?
    var mDestinationBusStopNumber : Int?
    var mDestinationBusStopLat : String?
    var mDestinationBusStopLng : String?
    var mDestinationBusStopStreetName : String?
    var mDestinationBusStopStreetNumber : Int?
    var mDestinationBusStopDistanceToDestination : Double?
}