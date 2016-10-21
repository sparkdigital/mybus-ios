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
        self.name = object.objectForKey("name") as! String
        self.description = object.objectForKey("description") as? String
        self.address = object.objectForKey("address") as? String
        self.photoUrl = object.objectForKey("photoUrl") as? String
        self.location = (object.objectForKey("lat") as! Double, object.objectForKey("lng") as! Double)
    }

    func getImage() -> UIImage {
        return UIImage(named: "tourist_spot")!
    }
}
