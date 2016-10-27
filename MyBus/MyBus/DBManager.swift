//
//  DBManager.swift
//  MyBus
//
//  Created by Lisandro Falconi on 10/18/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import RealmSwift

private let _sharedInstance = DBManager()

public class DBManager: NSObject {
    let db = try! Realm()

    // MARK: - Instantiation
    public class var sharedInstance: DBManager
    {
        return _sharedInstance
    }

    override init() {}

    func getCompleteBusRoutes(busLineName: String) -> Results<CompleteBusItineray>? {
        let results = db.objects(CompleteBusItineray.self).filter("busLineName = '\(busLineName)'")
        return results
    }

    func getFavourites() -> List<Location>? {
        let users = db.objects(User)
        if let user = users.first {
            return user.favourites
        }
        return nil
    }

    func getRecents() -> List<RoutePoint>? {
        let users = db.objects(User)
        if let user = users.first {
            return user.recents
        }
        return nil
    }

    func getUserProfile() -> User {
        let users = db.objects(User)

        if let user = users.first {
            return user
        } else {
            let user = User()
            db.beginWrite()
            db.add(user)
            try! db.commitWrite()
            return user
        }
    }

    func addRecent(newRecentPoint: RoutePoint) {
        let users = db.objects(User)
        if let user = users.first {
            try! db.write({
                let recentsEqualNew = user.recents.filter({ (recent) -> Bool in
                    return recent.latitude == newRecentPoint.latitude && recent.longitude == newRecentPoint.longitude
                })
                guard recentsEqualNew.count == 0 else {
                    return
                }

                if user.recents.count == 5 {
                    user.recents.removeLast()
                }
                user.recents.insert(newRecentPoint, atIndex: 0)
            })
        } else {
            let user = User()
            user.recents.append(newRecentPoint)
            try! db.write({
                db.add(user)
            })
        }
    }
    
    func addFavorite(newFavoritePlace: Location) {
        // Realms are used to group data together
        let realm = try! Realm() // Create realm pointing to default file
        let users = realm.objects(User)
         if users.count > 0
        {
            let user = users.first
            // Save your object
            try! realm.write
                {
                    user!.favourites.append(newFavoritePlace)
            }
        } else
        {
            let user = User()
            user.favourites.append(newFavoritePlace)
            realm.beginWrite()
            realm.add(user)
            try! realm.commitWrite()
        }
    }

    func removeFavorite(favoritePlace: Location) {
        // Realms are used to group data together
        let realm = try! Realm() // Create realm pointing to default file
        let users = realm.objects(User)
        
        if users.count > 0
        {
            let user = users.first
            // Remove your object
            try! realm.write
                {
                    if let indexLocation = user!.favourites.indexOf(favoritePlace) {
                        user?.favourites.removeAtIndex(indexLocation)
                    } else {
                        let location = user!.favourites.filter{($0.streetName == favoritePlace.streetName && $0.houseNumber == favoritePlace.houseNumber)}[0]
                        let indexLocation = user!.favourites.indexOf(location)
                        user?.favourites.removeAtIndex(indexLocation!)
                    }
            }
        } else
        {
            let user = User()
            if let indexLocation = user.favourites.indexOf(favoritePlace) {
                user.favourites.removeAtIndex(indexLocation)
            } else {
                let location = user.favourites.filter{($0.streetName == favoritePlace.streetName &&  $0.houseNumber == favoritePlace.houseNumber)}[0]
                let indexLocation = user.favourites.indexOf(location)
                user.favourites.removeAtIndex(indexLocation!)
            }
            realm.beginWrite()
            realm.add(user)
            try! realm.commitWrite()
        }
    }
    
    func updateFavorite(favoritePlace: Location) {
        // Realms are used to group data together
        let realm = try! Realm() // Create realm pointing to default file
        let users = realm.objects(User)
        
        if users.count > 0
        {
            let user = users.first
            //Update your object
            try! realm.write
                {
                    let location = user!.favourites.filter{($0.latitude == favoritePlace.latitude &&  $0.longitude == favoritePlace.longitude)}[0]
                    let indexLocation = user?.favourites.indexOf(location)
                    user?.favourites.replace(indexLocation!, object: favoritePlace)
            }
        } else
        {
            let user = User()
            let location = user.favourites.filter{($0.latitude == favoritePlace.latitude &&  $0.longitude == favoritePlace.longitude)}[0]
            let indexLocation = user.favourites.indexOf(location)
            user.favourites.replace(indexLocation!, object: favoritePlace)
            realm.beginWrite()
            realm.add(user)
            try! realm.commitWrite()
        }
    }
    
    func addDataModelEntry(object: Object){
        db.beginWrite()
        db.add(object, update: true)
        try! db.commitWrite()
    }
}
