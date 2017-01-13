//
//  BusesInformationViewController.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 9/9/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//
import UIKit

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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        progressNotification.showLoadingNotification(self.view)
        let bus = self.busesInformationDataSource.busInformation[indexPath.row]
        let busName = bus.1

        guard let busId = Int(bus.0) else {
            return
        }
        
        LoggingManager.sharedInstance.logEvent(LoggableAppEvent.ROUTE_SELECTED)
        
        SearchManager.sharedInstance.getCompleteRoute(busId, busLineName: busName) { (completeRoute, error) in
            if let route = completeRoute {
                self.searchViewProtocol?.newCompleteBusRoute(route)
                self.progressNotification.stopLoadingNotification(self.view)
            }
            self.progressNotification.stopLoadingNotification(self.view)

        }
    }

}
