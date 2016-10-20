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

    func getFavourites() -> List<Location> {
        let users = db.objects(User)
        if let user = users.first {
            return user.favourites
        }
        return List<Location>()
    }

    func getRecents() -> List<RoutePoint> {
        let users = db.objects(User)
        if let user = users.first {
            return user.recents
        }
        return List<RoutePoint>()
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

    func addDataModelEntry(object: Object){
        db.beginWrite()
        db.add(object, update: true)
        try! db.commitWrite()
    }
}
