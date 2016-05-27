//
//  MyBusService.swift
//  MyBus
//
//  Created by Lisandro Falconi on 5/26/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation

protocol MyBusServiceDelegate {

    func getBusLinesFromOriginDestination(latitudeOrigin : Double, longitudeOrigin : Double, latitudeDestination : Double, longitudeDestination : Double, completionHandler : ([BusRouteResult]?, NSError?) -> ())

    func getSingleResultRoadApi(idLine : Int, direction : Int, stop1: Int, stop2 : Int, completionHandler : (RoadResult?, NSError?) -> ())

    func getCombinedResultRoadApi(idLine1 : Int, idLine2 : Int, direction1 : Int, direction2: Int, L1stop1: Int, L1stop2 : Int, L2stop1: Int, L2stop2 : Int, completionHandler : (RoadResult?, NSError?) -> ())

}
