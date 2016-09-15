//
//  FavoriteTableViewCell.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 9/15/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    
    func loadItem(name: String,street: String,number: String) {
        self.name.text = name
        self.address.text = street+" "+number
    }
}