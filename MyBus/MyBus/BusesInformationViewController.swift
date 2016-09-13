//
//  BusesInformationViewController.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 9/9/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//
import UIKit
import RealmSwift

class BusesInformationViewController: UIViewController, UITableViewDelegate
{

    var busesInformationDataSource: BusesInformationDataSource!

    @IBOutlet weak var informationTableView: UITableView!
    var searchViewProtocol: MapBusRoadDelegate?
    let progressNotification = ProgressHUD()

    override func viewDidLoad()
    {
        self.busesInformationDataSource = BusesInformationDataSource()
        self.informationTableView.delegate = self
        self.informationTableView.dataSource = busesInformationDataSource
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        progressNotification.showLoadingNotification(self.view)
        let bus = self.busesInformationDataSource.busInformation[indexPath.row]
        let busId = bus.0
        let busName = bus.1
        SearchManager.sharedInstance.getCompleteRoute(Int(busId)!, busLineName: busName) { (completeRoute, error) in
            if let route = completeRoute {
                self.searchViewProtocol?.newCompleteBusRoute(route)
                self.progressNotification.stopLoadingNotification(self.view)
            }
            self.progressNotification.stopLoadingNotification(self.view)

        }
    }

}
