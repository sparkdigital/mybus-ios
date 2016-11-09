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
    
    func addFavorite(point:RoutePoint){
        DBManager.sharedInstance.addFavorite(point)
        loadFav()
    }
    
    func removeFavorite(atIndex:NSIndexPath) -> Bool{
        
        guard let favs = favorite else {
            return false
        }
        
        if let unfavedPoint:RoutePoint = favs[atIndex.row] {
            DBManager.sharedInstance.removeFavorite(unfavedPoint)
            loadFav()
            return true
        }else{
            return false
        }
       
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: FavoriteTableViewCell = tableView.dequeueReusableCellWithIdentifier("FavoriteTableViewCell", forIndexPath: indexPath) as! FavoriteTableViewCell
        cell.loadItem(favorite[indexPath.row].name, address: favorite[indexPath.row].address)
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let favs = self.favorite else {
            return 0
        }
        
        return favs.count
    }
}
