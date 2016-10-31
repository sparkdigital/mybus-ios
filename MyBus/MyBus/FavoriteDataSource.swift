//
//  FavoriteDataSource.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 10/11/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class FavoriteDataSource: NSObject, UITableViewDataSource {

    var favorite: List<RoutePoint>!

    override init() {
        self.favorite = DBManager.sharedInstance.getFavourites()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: FavoriteTableViewCell = tableView.dequeueReusableCellWithIdentifier("FavoriteTableViewCell", forIndexPath: indexPath) as! FavoriteTableViewCell
        cell.loadItem(favorite[indexPath.row].name, address: favorite[indexPath.row].address)
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorite.count
    }
}
