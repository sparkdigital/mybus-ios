//
//  SuggestedPlace.swift
//  MyBus
//
//  Created by Lisandro Falconi on 10/3/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import UIKit

class SuggestedPlace: SuggestionProtocol {
    var name: String = ""
    var description: String?
    var address: String?
    var photoUrl: String?
    var location: (latitude: Double, longitude: Double)

    init(object: NSDictionary){
        self.name = object.object(forKey: "name") as! String
        self.description = object.object(forKey: "description") as? String
        self.address = object.object(forKey: "address") as? String
        self.photoUrl = object.object(forKey: "photoUrl") as? String
        self.location = (object.object(forKey: "lat") as! Double, object.object(forKey: "lng") as! Double)
    }

    func getImage() -> UIImage {
        return UIImage(named: "tourist_spot")!
    }

    func getPoint() -> RoutePoint {
        let 📍 = RoutePoint()
        📍.latitude = self.location.latitude
        📍.longitude = self.location.longitude
        📍.address = self.address ?? self.name
        return 📍
    }
}
