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
            let resultData = bus.busRoutes.first!
            cell.busLine.text = resultData.busLineName
            cell.addressStopOrigin.text = "\(resultData.startBusStopStreetName!) \(resultData.startBusStopStreetNumber!)"
            cell.addressStopDestination.text = "\(resultData.destinationBusStopStreetName!) \(resultData.destinationBusStopStreetNumber!)"
            return cell
        case .Combined:
            let combinedResultCell = tableView.dequeueReusableCellWithIdentifier(combinedCellIdentifier, forIndexPath: indexPath) as! CombinedResultTableViewCell
            let firstResultData = bus.busRoutes.first!
            let secondResultData = bus.busRoutes.last!

            combinedResultCell.firstBusLine.text = "\(firstResultData.busLineName!) → \(secondResultData.busLineName!)"
            combinedResultCell.addressOriginStopFirstLine.text = "\(firstResultData.startBusStopStreetName!) \(firstResultData.startBusStopStreetNumber!)"
            combinedResultCell.addressDestinationStopFirstLine.text = "\(firstResultData.destinationBusStopStreetName!) \(firstResultData.destinationBusStopStreetNumber!)"

            combinedResultCell.addressOriginStopLastLine.text = "\(secondResultData.startBusStopStreetName!) \(secondResultData.startBusStopStreetNumber!)"
            let address = "\(secondResultData.destinationBusStopStreetName!) \(secondResultData.destinationBusStopStreetNumber!)"
            combinedResultCell.addressEndStopLastLine.text = address
            return combinedResultCell
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexSelectedRoute = indexPath.row
        busSearchResult!.indexSelected = indexSelectedRoute
        self.mainViewDelegate?.newResults(busSearchResult!)
    }



}
