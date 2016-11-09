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
            if var idBusIndex = Int(idBusIndex) {
                //Hacking the index
                if idBusIndex < 10 {
                    idBusIndex = idBusIndex - 1
                } else if idBusIndex < 41 {
                    idBusIndex = idBusIndex - 2
                } else {
                    idBusIndex = idBusIndex - 3
                }

                if let path = NSBundle.mainBundle().pathForResource("BusColors", ofType: "plist"), dict = (NSArray(contentsOfFile: path))!.objectAtIndex(idBusIndex) as? [String: String] {
                    if let color = dict["color"] {
                        return UIColor(hexString: color)
                    } else {
                        return defaultLineColor
                    }
                }
            }
            return defaultLineColor
        }
        set {}
    }
}
