//
//  BusesRatesTableViewCell.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 9/5/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import UIKit

class BusesRatesTableViewCell: UITableViewCell {

    @IBOutlet weak var busLineTextView: UITextView!
    @IBOutlet weak var busPriceLevel: UILabel!

    func loadItem(busLine: String, busPrice: String) {
        self.busLineTextView.text = busLine
        self.busPriceLevel.text = busPrice
    }
}
