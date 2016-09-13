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
    
    func loadItem(Id: String,busLine: String, color: UIColor) {
        self.id = Id
        self.busLine.text = busLine
        self.busColor.backgroundColor = color
    }
}