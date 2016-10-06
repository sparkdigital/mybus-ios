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

class MyBusMarkerAddressPoint: MyBusMarker {}
class MyBusMarkerBusStopPoint: MyBusMarker{}
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
                image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
                return MGLAnnotationImage(image: image, reuseIdentifier: identifier)
            }
            return nil
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

}
