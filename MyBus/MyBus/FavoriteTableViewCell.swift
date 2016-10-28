//
//  FavoriteTableViewCell.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 9/15/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    var index:Int!

    func loadItem(name: String, street: String, number: String = "") {
        self.name.text = name
        self.address.text = street+" "+number
        self.name.userInteractionEnabled = false
        self.address.userInteractionEnabled = false
    }

    func editCell() {
        self.name.userInteractionEnabled = true
        self.name.becomeFirstResponder()
        self.address.userInteractionEnabled = true
    }
    
    @IBAction func nameDidEndEdit(cell: AnyObject) {
        self.name.userInteractionEnabled = false
        self.name.resignFirstResponder()
        self.address.becomeFirstResponder()
     //   let location = self.favoriteDataSource.favorite[self.index]
     //   DBManager.sharedInstance.updateFavorite(location)
    }
    
    @IBAction func addressDidEndEdit(cell: AnyObject) {
        self.address.userInteractionEnabled = false
        self.address.resignFirstResponder()
      //  let location = self.favoriteDataSource.favorite[self.index]
     //   DBManager.sharedInstance.updateFavorite(location)
    }

}
