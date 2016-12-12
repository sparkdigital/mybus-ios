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
    
    @IBOutlet weak var busLine: UILabel!
   
    @IBOutlet weak var busColor: UIImageView!
   
    var id: String = ""
    
    func loadItem(busLineId: String,busLineName: String, color: UIColor) {
        self.id = busLineId
        self.busLine.text = busLineName
        self.busColor.backgroundColor = color
    }
}