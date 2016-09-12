//
//  BusesInformationDataSource.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 9/9/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import UIKit

class BusesInformationDataSource: NSObject, UITableViewDataSource {
    
    var busInformation : [(String, String,String)]
    
    override init() {
        self.busInformation = Configuration.bussesInformation()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: BusesInformationTableViewCell = tableView.dequeueReusableCellWithIdentifier("BusesInformationTableViewCell", forIndexPath: indexPath) as! BusesInformationTableViewCell
        let (id,busline,color) = busInformation[indexPath.row]
        cell.loadItem(id,busLine:busline,color: UIColor(hexString: color))
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busInformation.count
    }
    
}