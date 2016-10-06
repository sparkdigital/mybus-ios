//
//  SuggestionSearchTableViewCell.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 9/30/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import UIKit

class SuggestionSearchTableViewCell : UITableViewCell {
    
    @IBOutlet var imageCell: UIImageView!
    @IBOutlet weak var address: UILabel!
    
    func loadItem(street: String,type: SearchFilterType) {
        self.address.text = street
        switch type {
        case .Favorite:
            self.imageCell.image = UIImage(named: "favorite")
        case .Tourist:
            self.imageCell.image = UIImage(named: "tourist_spot")
        case.Search:
            self.imageCell.image = UIImage(named: "search")
        }
    }
}
