//
//  CompleteBusRoute.swift
//  MyBus
//
//  Created by Lisandro Falconi on 9/7/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import SwiftyJSON

class CompleteBusRoute {
    var busLineName: String = " "
    var goingPointList: [RoutePoint]?
    var returnPointList: [RoutePoint]?

    func parseOneWayBusRoute(json: JSON, busLineName: String) -> CompleteBusRoute {
        return CompleteBusRoute()
    }
}
