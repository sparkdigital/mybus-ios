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

open class DBManager: NSObject {
    var db: Realm?
    var currentUser: User? {
        if let db = db {
            let users = db.objects(User.self)
            if let user = users.first {
                return user
            }
        }
        return nil
    }

    // MARK: - Instantiation
    open class var sharedInstance: DBManager {
        return _sharedInstance
    }

    override init() {
        super.init()
        do {
            self.db = try Realm()
        } catch let error as NSError {
            NSLog("Error opening realm: \(error)")
        }
    }

    func getCompleteBusRoutes(_ busLineName: String) -> Results<CompleteBusItineray>? {
        if let db = db {
            let results = db.objects(CompleteBusItineray.self).filter("busLineName = '\(busLineName)'")
            return results
        }
        return nil
    }

    func getFavourites() -> List<RoutePoint>? {
        return currentUser?.favourites
    }

    func getRecents() -> List<RoutePoint>? {
        return currentUser?.recents
    }

    func getUserProfile() -> User? {
        if let user = currentUser {
            return user
        } else {
            let user = User()
            self.addDataModelEntry(user)
            return user
        }
    }

    func addRecent(_ newRecentPoint: RoutePoint) {
        if let user = currentUser, let db = db {
            do {
                try db.write({
                    let recentsEqualNew = user.recents.filter({ (recent) -> Bool in
                        return recent.latitude == newRecentPoint.latitude && recent.longitude == newRecentPoint.longitude || newRecentPoint.address == recent.address
                    })
                    guard recentsEqualNew.count == 0 else {
                        return
                    }

                    if user.recents.count == 5 {
                        user.recents.removeLast()
                    }
                    user.recents.insert(newRecentPoint, at: 0)
                })
            } catch let error as NSError {
                NSLog("### Realm ### Error writing a new recent : \(error)")
            }

        } else {
            let user = User()
            user.recents.append(newRecentPoint)
            self.addDataModelEntry(user)
        }
    }

    func addFavorite(_ newFavoritePlace: RoutePoint) {
        if let user = currentUser, let db = db {
            do {
                try db.write {
                    let favsEqualNew = user.favourites.filter({ (favorite) -> Bool in
                        return favorite.latitude == newFavoritePlace.latitude && favorite.longitude == newFavoritePlace.longitude
                    })
                    guard favsEqualNew.count == 0 else {
                        return
                    }

                    user.favourites.append(newFavoritePlace)
                }
            } catch let error as NSError {
                NSLog("### Realm ### Error writing a new favorite : \(error)")
            }

        } else {
            let user = User()
            user.favourites.append(newFavoritePlace)
            self.addDataModelEntry(user)
        }
    }

    func removeFavorite(_ favoritePlace: RoutePoint) {
        if let user = currentUser, let db = db {
            do {
                try db.write {
                    if let indexLocation = user.favourites.index(of: favoritePlace) {
                        user.favourites.remove(at: indexLocation)
                    } else {
                        let location = user.favourites.filter {($0.address == favoritePlace.address)}[0]
                        if let indexLocation = user.favourites.index(of: location) {
                            user.favourites.remove(at: indexLocation)
                        }
                    }
                }
            } catch let error as NSError {
                NSLog("### Realm ### Error removing a favorite : \(error)")
            }

        } else {
            let user = User()
            self.addDataModelEntry(user)
        }
    }

    func updateFavorite(_ favoritePlace: RoutePoint, name: String?, newFavLocation: RoutePoint?) {
        if let user = currentUser, let db = db {
            do {
                try db.write {
                    let location = user.favourites.filter {($0.latitude == favoritePlace.latitude &&  $0.longitude == favoritePlace.longitude)}[0]
                    if let indexLocation = user.favourites.index(of: location) {
                        favoritePlace.name = name ?? favoritePlace.name
                        if let updatedLocation = newFavLocation {
                            favoritePlace.address = updatedLocation.address 
                            favoritePlace.latitude = updatedLocation.latitude 
                            favoritePlace.longitude = updatedLocation.longitude 
                        }
                        user.favourites.replace(index: indexLocation, object: favoritePlace)
                    }
                }
            } catch let error as NSError {
                NSLog("### Realm ### Error updating a favorite : \(error)")
            }
        }
    }

    func updateCompleteBusItinerary(_ itinerary: CompleteBusRoute) {
        let itineray = CompleteBusItineray()
        itineray.busLineName = itinerary.busLineName
        itineray.goingItineraryPoint.append(objectsIn: itinerary.goingPointList)
        itineray.returnItineraryPoint.append(objectsIn: itinerary.returnPointList)
        itineray.savedDate = Date()

        self.addDataModelEntry(itineray, isUpdate: true)
    }

    func findOneCompleteBusItinerary(_ busLine: String) -> CompleteBusItineray? {
        if let db = db {
            let results = db.objects(CompleteBusItineray.self).filter("busLineName = '\(busLine)'")
            return results.first ?? nil
        } else {
            return nil
        }
    }

    func addDataModelEntry(_ object: Object, isUpdate: Bool? = false) {
        if let db = db {
            do {
                db.beginWrite()
                db.add(object, update: isUpdate!)
                try db.commitWrite()
            } catch let error as NSError {
                NSLog("### Realm ### Error writing: \(error)")
            }

        }
    }
}
