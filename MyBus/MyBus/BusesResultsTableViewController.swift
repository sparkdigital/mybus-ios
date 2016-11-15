//
//  BusesResultsTableViewController.swift
//  MyBus
//
//  Created by Lisandro Falconi on 10/11/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

class BusesResultsTableViewController: UITableViewController {

    // MARK: Properties
    let simpleCellIdentifier = "SimpleBusResultCell"
    let combinedCellIdentifier = "CombinedResultTableViewCell"
    var busSearchResult: BusSearchResult?
    var buses = [BusRouteResult]()
    var mainViewDelegate: MapBusRoadDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 190.0, 0.0)
    }

    func loadBuses(buses: BusSearchResult) {
        self.busSearchResult = buses
        self.buses = buses.busRouteOptions
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 135.0
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buses.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let bus = buses[indexPath.row]


        switch bus.busRouteType {
        case .Single:
            let cell = tableView.dequeueReusableCellWithIdentifier(simpleCellIdentifier, forIndexPath: indexPath) as! SimpleResultTableViewCell
            guard let busOption = bus.busRoutes.first else {
                return cell
            }
            cell.busLine.text = busOption.busLineName
            cell.addressStopOrigin.text = "\(busOption.startBusStopStreetName) \(busOption.startBusStopStreetNumber)"

            cell.addressStopDestination.text = "\(busOption.destinationBusStopStreetName) \(busOption.destinationBusStopStreetNumber)"
            return cell
        case .Combined:
            let combinedResultCell = tableView.dequeueReusableCellWithIdentifier(combinedCellIdentifier, forIndexPath: indexPath) as! CombinedResultTableViewCell
            guard let firstBusOfOption = bus.busRoutes.first, let secondBusOfOption = bus.busRoutes.last else {
                return combinedResultCell
            }
            combinedResultCell.firstBusLine.text = "\(firstBusOfOption.busLineName) → \(secondBusOfOption.busLineName)"
            combinedResultCell.addressOriginStopFirstLine.text = "\(firstBusOfOption.startBusStopStreetName) \(firstBusOfOption.startBusStopStreetNumber)"
            combinedResultCell.addressDestinationStopFirstLine.text = "\(firstBusOfOption.destinationBusStopStreetName) \(firstBusOfOption.destinationBusStopStreetNumber)"

            combinedResultCell.addressOriginStopLastLine.text = "\(secondBusOfOption.startBusStopStreetName) \(secondBusOfOption.startBusStopStreetNumber)"
            let address = "\(secondBusOfOption.destinationBusStopStreetName) \(secondBusOfOption.destinationBusStopStreetNumber)"
            combinedResultCell.addressEndStopLastLine.text = address
            return combinedResultCell
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let busSearchResult = busSearchResult else {
            return
        }
        let indexSelectedRoute = indexPath.row
        busSearchResult.indexSelected = indexSelectedRoute
        self.mainViewDelegate?.newResults(busSearchResult)
    }



}
