//
//  BusesInformationTableViewCell.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 9/9/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import UIKit

class BusesInformationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var BusLine: UITextView!
    @IBOutlet weak var BusColor: UIImageView!
  
    func loadItem(BusLine: String, Color: UIColor) {
        self.BusLine.text = BusLine
        self.BusColor.backgroundColor = Color
    }
}