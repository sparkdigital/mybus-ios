//
//  MyBusMarker.swift
//  MyBus
//
//  Created by Lisandro Falconi on 10/6/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import Mapbox
import UIKit

class MyBusMarkerOriginPoint: MyBusMarker {}
class MyBusMarkerDestinationPoint: MyBusMarker {}
class MyBusMarkerBusStopPoint: MyBusMarker{}
class MyBusMarkerIntermediateBusStopPoint: MyBusMarker{}
class MyBusMarkerRechargePoint: MyBusMarker{}

class MyBusMarkerCompleteRoutePoint: MyBusMarker{}
class MyBusMarkerStartCompleteRoutePoint: MyBusMarkerCompleteRoutePoint{}
class MyBusMarkerEndCompleteRoutePoint: MyBusMarkerCompleteRoutePoint{}
class MyBusMarkerSameStartEndCompleteRoutePoint: MyBusMarkerCompleteRoutePoint{}

class MyBusMarker: MGLPointAnnotation {
    var markerImageIdentifier: String?
    var markerImage: MGLAnnotationImage? {
        get {
            guard let identifier = markerImageIdentifier else { return nil }
            if var image = UIImage(named: identifier) {
                image = image.withAlignmentRectInsets(UIEdgeInsets.init(top: 0, left: 0, bottom: image.size.height/2, right: 0))
                return MGLAnnotationImage(image: image, reuseIdentifier: identifier)
            }
            return nil
        }
    }
    var markerView: MGLAnnotationView? {
        get {
            guard let identifier = markerImageIdentifier, (self is MyBusMarkerOriginPoint || self is MyBusMarkerDestinationPoint) else { return nil }
            return MyBusMarkerAnnotationView(reuseIdentifier: identifier)
        }
    }


    // MARK: MyBusMarker Constructor
    init(position: CLLocationCoordinate2D, title: String, subtitle: String? = "", imageIdentifier: String?) {
        super.init()
        self.coordinate = position
        self.title = title
        self.subtitle = subtitle
        self.markerImageIdentifier = imageIdentifier
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
