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

    @IBOutlet weak var busPriceLevel: UILabel!
    @IBOutlet weak var busLineLabel: UILabel!

    func loadItem(_ busLine: String, busPrice: String) {
        self.busLineLabel.text = busLine
        self.busPriceLevel.text = busPrice
    }
}
