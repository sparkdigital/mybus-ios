//
//  SearchDataSource.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 9/14/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class SearchDataSource: NSObject, UITableViewDataSource {

    var favourites: List<RoutePoint>!
    var recents: List<RoutePoint>!

    override init() {
        super.init()
        loadRecents()
    }

    func loadRecents() {
        recents = DBManager.sharedInstance.getRecents()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("RecentTableViewCell", forIndexPath: indexPath) as! RecenTableViewCell
            cell.loadItem(recents[indexPath.row].address)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteTableViewCell", forIndexPath: indexPath) as! FavoriteTableViewCell
            cell.loadItem(favourites[indexPath.row].address, street: favourites[indexPath.row].address)
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteTableViewCell", forIndexPath: indexPath) as UITableViewCell
            return cell
        }
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let listRecents = recents {
                return listRecents.count
            }
            return 0
        case 1:
            if let listFavs = favourites {
                return listFavs.count
            }
            return 0
        default:
            return recents.count
        }
    }


    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "RECIENTES"
        case 1:
            return "FAVORITOS"
        default:
            return ""
        }
    }
}
