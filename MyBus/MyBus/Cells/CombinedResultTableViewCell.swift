//
//  CombinedResultTableViewCell.swift
//  MyBus
//
//  Created by Lisandro Falconi on 10/11/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

class CombinedResultTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var firstBusLine: UILabel!
    @IBOutlet weak var addressOriginStopFirstLine: UILabel!
    @IBOutlet weak var addressDestinationStopFirstLine: UILabel!

    @IBOutlet weak var addressOriginStopLastLine: UILabel!
    @IBOutlet weak var addressEndStopLastLine: UILabel!

    @IBOutlet weak var firstBusArrivalTime: UILabel!
}
