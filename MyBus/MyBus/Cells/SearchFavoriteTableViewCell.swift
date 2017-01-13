//
//  SearchFavoriteTableViewCell.swift
//  MyBus
//
//  Created by Lisandro Falconi on 11/16/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

class SearchFavoriteTableViewCell: UITableViewCell {
    var favorite: RoutePoint?

    @IBOutlet weak var favoriteNameLabel: UILabel!
    @IBOutlet weak var favoriteAddressLabel: UILabel!
    func loadItem(_ favorite: RoutePoint) {
        self.favorite = favorite
        setUpFields()
    }

    func setUpFields() {
        guard let fav = self.favorite else {
            return
        }
        self.favoriteNameLabel.text = fav.name
        self.favoriteAddressLabel.text = fav.address
    }

}
