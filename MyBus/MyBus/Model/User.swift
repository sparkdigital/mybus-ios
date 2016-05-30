//
//  User.swift
//  MyBus
//
//  Created by Lisandro Falconi on 4/18/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object
{
    dynamic var name = "DeviceiOS"
    let favourites = List<Location>()

    func addFavouriteLocation(favLocation: Location)
    {

        // Realms are used to group data together
        let realm = try! Realm() // Create realm pointing to default file
        let users = realm.objects(User)

        if users.count > 0
        {
            let user = users.first
            // Save your object
            try! realm.write
            {
                user!.favourites.append(favLocation)
            }
        } else
        {
            let user = User()
            user.favourites.append(favLocation)
            realm.beginWrite()
            realm.add(user)
            try! realm.commitWrite()
        }
    }
}
