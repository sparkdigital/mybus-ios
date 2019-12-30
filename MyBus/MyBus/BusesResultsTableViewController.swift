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
    }

    func loadBuses(_ buses: BusSearchResult) {
        self.busSearchResult = buses
        self.buses = buses.busRouteOptions
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()

        let indexPath: IndexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.none, animated: true)

        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135.0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bus = buses[indexPath.row]


        switch bus.busRouteType {
        case .single:
            let cell = tableView.dequeueReusableCell(withIdentifier: simpleCellIdentifier, for: indexPath) as! SimpleResultTableViewCell
            guard let busOption = bus.busRoutes.first else {
                return cell
            }
            cell.busLine.text = busOption.busLineName
            cell.addressStopOrigin.text = "\(busOption.startBusStopStreetName) \(busOption.startBusStopStreetNumber)"
            if let nextArrival = busOption.busArrivalTime.first {
                cell.busArrivalTime.text = "Llega en \(nextArrival) min"
            }
            cell.addressStopDestination.text = "\(busOption.destinationBusStopStreetName) \(busOption.destinationBusStopStreetNumber)"
            return cell
        case .combined:
            let combinedResultCell = tableView.dequeueReusableCell(withIdentifier: combinedCellIdentifier, for: indexPath) as! CombinedResultTableViewCell
            guard let firstBusOfOption = bus.busRoutes.first, let secondBusOfOption = bus.busRoutes.last else {
                return combinedResultCell
            }
            if let nextArrival = firstBusOfOption.busArrivalTime.first {
                combinedResultCell.firstBusArrivalTime.text = "En \(nextArrival)'"
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let busSearchResult = busSearchResult else {
            return
        }
        let indexSelectedRoute = indexPath.row
        busSearchResult.indexSelected = indexSelectedRoute
        self.mainViewDelegate?.newResults(busSearchResult)
    }



}
