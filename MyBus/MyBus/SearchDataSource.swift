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
        loadFavs()
    }

    func loadRecents() {
        recents = DBManager.sharedInstance.getRecents()
    }

    func loadFavs() {
        favourites = DBManager.sharedInstance.getFavourites()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTableViewCell", for: indexPath) as! RecenTableViewCell
            cell.loadItem(recents[indexPath.row].address)
            return cell
        case 1:
            guard let favs = favourites else {
                return UITableViewCell()
            }

            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchFavoriteTableViewCell", for: indexPath) as! SearchFavoriteTableViewCell
            cell.loadItem(favs[indexPath.row])

            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchFavoriteTableViewCell", for: indexPath) as UITableViewCell
            return cell
        }
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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


    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
