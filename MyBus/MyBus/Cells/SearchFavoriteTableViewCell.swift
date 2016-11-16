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
    func loadItem(favorite: RoutePoint) {
        self.favoriteNameLabel.text = favorite.name
        self.favoriteAddressLabel.text = favorite.address
        self.favorite = favorite
    }
}
