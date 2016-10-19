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
 
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Borrar") { (action , indexPath ) -> Void in
            self.editing = false
            self.favoriteDataSource.deleteFavoritePlace(indexPath.row)
            self.favoriteTableView.reloadData()
        };
      
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Editar") { (action , indexPath ) -> Void in
            let cell: FavoriteTableViewCell = self.favoriteTableView.cellForRowAtIndexPath(indexPath) as! FavoriteTableViewCell
            cell.editCell()
            self.favoriteTableView.setEditing(false, animated: true)
        }
        editAction.backgroundColor = UIColor(hexString: "0288D1")
        return [deleteAction,editAction]
    }
}


