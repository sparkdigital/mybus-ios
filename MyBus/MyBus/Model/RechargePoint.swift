//
//  RechargePoint.swift
//  MyBus
//
//  Created by Lisandro Falconi on 9/13/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import SwiftyJSON
import Mapbox

struct RechargePoint {
    let id: String
    let name: String
    let address: String
    let location: (latitude: Double, longitude: Double)
    let openTime: String
    let distance: Double?
}

extension RechargePoint {
    init?(json: JSON) {
        guard let id = json["Id"].string,
            let name = json["Name"].string,
            let address = json["Adress"].string,
            let latitude = json["Lat"].string,
            let longitude = json["Lng"].string,
            let openTime = json["OpenTime"].string,
            let distance = json["Distance"].string
            else {
                return nil
        }

        self.id = id
        self.name = name
        self.address = address
        self.location = (Double(latitude)!, Double(longitude)!)
        self.openTime = openTime
        self.distance = Double(distance)
    }

    func getLatLong() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
}
