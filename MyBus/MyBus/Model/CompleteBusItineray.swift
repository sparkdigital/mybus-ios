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
    @objc dynamic var busLineName: String = ""
    @objc dynamic var savedDate: Date = Date()
    let goingItineraryPoint = List<RoutePoint>()
    let returnItineraryPoint = List<RoutePoint>()

    override static func primaryKey() -> String? {
        return "busLineName"
    }
}
