//
//  SearchSuggestionsDataSource.swift
//  MyBus
//
//  Created by Lisandro Falconi on 7/22/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class SearchSuggestionsDataSource: NSObject, UITableViewDataSource {

    var bestMatches: [String] = []
    var favourites: List<Location>!

    init(streetList: [String] = []) {
        self.bestMatches = streetList
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("FavoritesIdentifier", forIndexPath: indexPath) as UITableViewCell
            return buildFavCell(indexPath, cell: cell)
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("BestMatchesIdentifier", forIndexPath: indexPath) as! BestMatchTableViewCell
            cell.name.text = self.bestMatches[indexPath.row]
            return cell

        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("BestMatchesIdentifier", forIndexPath: indexPath) as UITableViewCell

            return cell
        }
    }

    func buildFavCell(indexPath: NSIndexPath, cell: UITableViewCell) -> UITableViewCell {
        let fav = favourites[indexPath.row]
        let cellLabel: String
        let address = "\(fav.streetName) \(fav.houseNumber)"
        if fav.name.isEmpty {
            cellLabel = address
        } else {
            cellLabel = fav.name
            cell.detailTextLabel?.text = address
        }
        cell.textLabel?.text = cellLabel
        return cell
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let listFavs = favourites {
                return listFavs.count
            }
            return 0
        case 1:
            return bestMatches.count
        default:
            return bestMatches.count
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Favorites"
        case 1:
            return "Best Matches"
        default:
            return "Best Matches"
        }
    }
}
