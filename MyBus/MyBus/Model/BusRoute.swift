//
//  BusRoute.swift
//  MyBus
//
//  Created by Lisandro Falconi on 4/25/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation

class BusRoute : NSObject {
    var mIdBusLine : Int? = 0
    var mBusLineName : String? = " "
    var mBusLineDirection : Int? = 0
    var mBusLineColor : String? = " "
    var mStartBusStopNumber : Int? = 0
    var mStartBusStopLat : String? = " "
    var mStartBusStopLng : String? = " "
    var mStartBusStopStreetName : String? = " "
    var mStartBusStopStreetNumber : Int? = 0
    var mStartBusStopDistanceToOrigin : Double?
    var mDestinationBusStopNumber : Int? = 0
    var mDestinationBusStopLat : String? = " "
    var mDestinationBusStopLng : String? = " "
    var mDestinationBusStopStreetName : String? = " "
    var mDestinationBusStopStreetNumber : Int? = 0
    var mDestinationBusStopDistanceToDestination : Double? = 0.0
    
}