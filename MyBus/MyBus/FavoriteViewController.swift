//
//  FavoriteViewController.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 10/11/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteViewController: UIViewController, UITableViewDelegate
{
    
    var favoriteDataSource: FavoriteDataSource!
    
    @IBOutlet weak var favoriteTableView: UITableView!
    
    override func viewDidLoad()
    {
        self.favoriteDataSource = FavoriteDataSource()
        self.favoriteTableView.delegate = self
        self.favoriteTableView.dataSource = favoriteDataSource
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    @IBAction func deleteFavoritePlace(sender: AnyObject) {
        let button = sender as! UIButton
        let buttonRow = button.tag
        self.favoriteDataSource.deleteFavoritePlace(buttonRow)
        self.favoriteTableView.reloadData()
    }
    
    @IBAction func addFavoritePlace(place: Location) {
        self.favoriteDataSource.addFavoritePlace(place)
        self.favoriteTableView.reloadData()
    }
    
}
