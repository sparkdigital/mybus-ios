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

    var busInformation: [(String, String, String)]

    override init() {
        self.busInformation = Configuration.bussesInformation()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell: BusesInformationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BusesInformationTableViewCell", for: indexPath) as! BusesInformationTableViewCell
        let (id, busline, color) = busInformation[indexPath.row]
        cell.loadItem(id, busLineName:busline, color: UIColor(hexString: color))

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busInformation.count
    }

}
