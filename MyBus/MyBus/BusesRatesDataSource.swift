//
//  BusesRatesDataSource.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 9/5/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import UIKit


class BusesRatesDataSource: NSObject, UITableViewDataSource {
    
    var busRate : [(String, String)]

    override init() {
        self.busRate = Configuration.bussesRates()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: BusesRatesTableViewCell = tableView.dequeueReusableCellWithIdentifier("BusesRatesTableViewCell", forIndexPath: indexPath) as! BusesRatesTableViewCell
        let (busline, busprice) = busRate[indexPath.row]
        cell.loadItem(busline,busPrice: busprice)
        return cell
    }
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return busRate.count
    }
    
}