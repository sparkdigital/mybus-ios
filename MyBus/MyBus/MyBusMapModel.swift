//
//  MyBusMapModel.swift
//  MyBus
//
//  Created by Sebastian Fink on 10/14/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation

enum MyBusMapModelNotificationKey: String {
    case originChanged = "markerOriginChanged"
    case destinationChanged = "markerDestinationChanged"
    case currentRoadChanged = "currentRoadChanged"
    case rechargePointsChanged = "rechargePointsChanged"
    case completeRouteChanged = "completeRouteChanged"
}


class MyBusMapRoad {
    var roadMarkers: [MyBusMarker]!
    var roadIntermediateBusStopMarkers: [MyBusMarkerIntermediateBusStopPoint]!
    var roadPolyline: [MyBusPolyline]!
    var walkingPath: [MyBusPolyline]!
}

class MyBusMapRoute {
    var goingRouteMarkers: [MyBusMarker]!
    var goingRoute: MyBusPolyline!

    var returnRouteMarkers: [MyBusMarker]!
    var returnRoute: MyBusPolyline!

    var markers: [MyBusMarker]!
    var polyline: [MyBusPolyline]!
}


open class MyBusMapModel: NSObject {

    static let kPropertyChangedDescriptor: String = "MapPropertyChanged"

    // Origin
    var originMarker: MyBusMarkerOriginPoint? {
        didSet {
            notifyPropertyChanged(MyBusMapModelNotificationKey.originChanged, object: originMarker)
        }
    }

    // Destination
    var destinationMarker: MyBusMarkerDestinationPoint? {
        didSet {
            notifyPropertyChanged(MyBusMapModelNotificationKey.destinationChanged, object: destinationMarker)
        }
    }

    // Road to display
    var currentRoad: MyBusMapRoad? {
        didSet {
            notifyPropertyChanged(MyBusMapModelNotificationKey.currentRoadChanged, object: currentRoad)
        }
    }

    // Recharge Points to display
    var rechargePointList: [MyBusMarkerRechargePoint]? {
        didSet {
            notifyPropertyChanged(MyBusMapModelNotificationKey.rechargePointsChanged, object: rechargePointList as AnyObject?)
        }
    }

    // Complete Route selected
    var completeBusRoute: MyBusMapRoute? {
        didSet {
            notifyPropertyChanged(MyBusMapModelNotificationKey.completeRouteChanged, object: completeBusRoute)
        }
    }


    override init(){
        super.init()
    }

    func clearModel(){
        self.originMarker = nil
        self.destinationMarker = nil
        self.currentRoad = nil
        self.rechargePointList = nil
        self.completeBusRoute = nil
    }


    fileprivate func notifyPropertyChanged(_ propertyKey: MyBusMapModelNotificationKey, object: AnyObject?){
        if object == nil {
            // Don't send the notification if the property has been set to nil
            NSLog("\(propertyKey.rawValue) is now nil")
        }else{
            NotificationCenter.default.post(name: Notification.Name(rawValue: propertyKey.rawValue), object: nil, userInfo: [MyBusMapModel.kPropertyChangedDescriptor:object!])
        }
    }


}
