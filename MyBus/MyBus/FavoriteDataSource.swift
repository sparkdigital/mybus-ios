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
    
    var favorite: List<Location>!
    
    override init() {
        //  self.favorite = Configuration.bussesInformation()
        let l = Location()
        l.name = "Casa de la abuela"
        l.streetName = "Serrano"
        l.houseNumber = 1110
        
        let l1 = Location()
        l1.name = "Casa de mama"
        l1.streetName = "Bolivia"
        l1.houseNumber = 54
        self.favorite = List<Location>()
        self.favorite.append(l)
        self.favorite.append(l1)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: FavoriteTableViewCell = tableView.dequeueReusableCellWithIdentifier("FavoriteTableViewCell", forIndexPath: indexPath) as! FavoriteTableViewCell
        cell.loadItem(favorite[indexPath.row].name,street: favorite[indexPath.row].streetName, number:String(favorite[indexPath.row].houseNumber))
        cell.delete.tag = indexPath.row;
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorite.count
    }
    
    func deleteFavoritePlace(index : Int) {
        self.favorite.removeAtIndex(index)
    }
    
    func addFavoritePlace(place : Location) {
        self.favorite.append(place)
    }
}

