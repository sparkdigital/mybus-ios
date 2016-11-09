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
    
    @IBOutlet weak var BusLine: UITextView!
    @IBOutlet weak var BusPrice: UILabel!
    
    func loadItem(BusLine: String, BusPrice: String) {
        self.BusLine.text = BusLine
        self.BusPrice.text = BusPrice
    }
}