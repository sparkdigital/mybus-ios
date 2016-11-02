//
//  RecentTableViewCell.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 9/15/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

class RecenTableViewCell: UITableViewCell {

    @IBOutlet weak var address: UILabel!

    func loadItem(street: String) {
        self.address.text = street
    }
}
