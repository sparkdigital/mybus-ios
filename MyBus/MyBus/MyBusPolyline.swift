//
//  MyBusPolyline.swift
//  MyBus
//
//  Created by Lisandro Falconi on 10/3/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import Mapbox

class MyBusPolyline: MGLPolyline {
    var color: UIColor?
}

class MyBusWalkingPolyline: MyBusPolyline {
    override var color: UIColor? {
        get { return UIColor.grayColor() }
        set {}
    }
}
class MyBusGoingCompleteBusRoutePolyline: MyBusPolyline {
    override var color: UIColor? {
        get { return UIColor(hexString: "0288D1") }
        set {}
    }
}
class MyBusReturnCompleteBusRoutePolyline: MyBusPolyline {
    override var color: UIColor? {
        get { return UIColor(hexString: "EE236F") }
        set {}
    }
}
class MyBusRoadResultPolyline: MyBusPolyline {
    var busLineIdentifier: String?
    override var color: UIColor? {
        get {
            let defaultLineColor = UIColor.grayColor()
            guard let idBusIndex = busLineIdentifier else {
                return defaultLineColor
            }
            let busColor = Configuration.bussesInformation().filter{ $0.0 == idBusIndex }.first!.2
            return UIColor(hexString: busColor)
        }
        set {}
    }
}
