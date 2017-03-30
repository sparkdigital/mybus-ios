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
        super.init()
    }

    func loadFav() {
        self.favorite = DBManager.sharedInstance.getFavourites()
    }

    func addFavorite(_ point: RoutePoint){
        DBManager.sharedInstance.addFavorite(point)
        loadFav()
    }

    func removeFavorite(_ atIndex: IndexPath) -> Bool{

        guard let favs = favorite else {
            return false
        }

        if favs.count > atIndex.row {
            let unfavedPoint: RoutePoint = favs[atIndex.row]
            DBManager.sharedInstance.removeFavorite(unfavedPoint)
            loadFav()
            return true
        }else{
            return false
        }


    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell: FavoriteTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as! FavoriteTableViewCell
        cell.loadItem(favorite[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let favs = self.favorite else {
            return 0
        }

        return favs.count
    }
}
