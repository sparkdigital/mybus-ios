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
    var favourites = List<Location> ()
    var recents = List<RoutePoint>()

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
    
    func removeFavouriteLocation(favLocation: Location)
    {
        // Realms are used to group data together
        let realm = try! Realm() // Create realm pointing to default file
        let users = realm.objects(User)
        
        if users.count > 0
        {
            let user = users.first
            // Remove your object
            try! realm.write
            {
                if let indexLocation = user!.favourites.indexOf(favLocation) {
                    user?.favourites.removeAtIndex(indexLocation)
                } else {
                   let location = user!.favourites.filter{($0.streetName == favLocation.streetName && $0.houseNumber == favLocation.houseNumber)}[0]
                    let indexLocation = user!.favourites.indexOf(location)
                    user?.favourites.removeAtIndex(indexLocation!)
                }
            }
        } else
        {
            let user = User()
            if let indexLocation = user.favourites.indexOf(favLocation) {
                user.favourites.removeAtIndex(indexLocation)
            } else {
               let location = user.favourites.filter{($0.streetName == favLocation.streetName &&  $0.houseNumber == favLocation.houseNumber)}[0]
                let indexLocation = user.favourites.indexOf(location)
                user.favourites.removeAtIndex(indexLocation!)
            }
            realm.beginWrite()
            realm.add(user)
            try! realm.commitWrite()
        }
    }
    
    func updateFavouriteLocation(favLocation: Location)
    {
        // Realms are used to group data together
        let realm = try! Realm() // Create realm pointing to default file
        let users = realm.objects(User)
        
        if users.count > 0
        {
            let user = users.first
            //Update your object
            try! realm.write
            {
                let location = user!.favourites.filter{($0.latitude == favLocation.latitude &&  $0.longitude == favLocation.longitude)}[0]
                let indexLocation = user?.favourites.indexOf(location)
                user?.favourites.replace(indexLocation!, object: favLocation)
            }
        } else
        {
            let user = User()
            let location = user.favourites.filter{($0.latitude == favLocation.latitude &&  $0.longitude == favLocation.longitude)}[0]
            let indexLocation = user.favourites.indexOf(location)
            user.favourites.replace(indexLocation!, object: favLocation)
            realm.beginWrite()
            realm.add(user)
            try! realm.commitWrite()
        }
    }
}
