//
//  CompleteBusItineray.swift
//  MyBus
//
//  Created by Lisandro Falconi on 9/19/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import RealmSwift

class CompleteBusItineray: Object {
    dynamic var busLineName: String = ""
    dynamic var savedDate: NSDate = NSDate()
    let goingIntinerayPoint = List<RoutePoint>()
    let returnIntinerayPoint = List<RoutePoint>()
}
