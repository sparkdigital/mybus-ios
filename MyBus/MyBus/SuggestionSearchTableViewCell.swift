//
//  SuggestionSearchTableViewCell.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 9/30/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import UIKit

class SuggestionSearchTableViewCell: UITableViewCell {

    @IBOutlet var imageCell: UIImageView!
    @IBOutlet weak var address: UILabel!

    func loadItem(_ suggestion: SuggestionProtocol) {
        self.address.text = suggestion.name
        self.imageCell.image = suggestion.getImage()
    }
}
