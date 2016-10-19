//
//  SearchViewController.swift
//  MyBus
//
//  Created by Marcos Vivar on 4/13/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit
import Mapbox
import RealmSwift

protocol MapBusRoadDelegate {
    //func newBusRoad(mapBusRoad: MapBusRoad)
    func newResults(busSearchResult: BusSearchResult)
    func newOrigin(coordinate: CLLocationCoordinate2D, address: String)
    func newDestination(coordinate: CLLocationCoordinate2D, address: String)
    func newCompleteBusRoute(route: CompleteBusRoute)
    func newOrigin(routePoint: RoutePoint)
    func newDestination(routePoint: RoutePoint)
    func newOriginWithCurrentLocation()
    func newDestinationWithCurrentLocation()
}

protocol MainViewDelegate: class {
    func loadPositionMainView()
    func loadPostionFromFavsRecents(position: RoutePoint)
}

class SearchViewController: UIViewController, UITableViewDelegate
{

    @IBOutlet weak var searchTableView: UITableView!

    var mainViewDelegate: MainViewDelegate?
    var busResults: [String] = []
    var bestMatches: [String] = []
    var favourites: List<Location>?
    var streetSuggestionsDataSource: SearchDataSource!
    let progressNotification = ProgressHUD()

    // MARK: - View Lifecycle Methods

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.streetSuggestionsDataSource = SearchDataSource()
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = streetSuggestionsDataSource

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedCurrentLocation))
        let view = UINib(nibName:"HeaderTableView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
        view.addGestureRecognizer(tap)
        self.searchTableView.tableHeaderView = view
    }

    func tappedCurrentLocation(){
        self.mainViewDelegate?.loadPositionMainView()
    }

    override func viewDidAppear(animated: Bool) {}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        switch indexPath.section {
        case 0:
            let selectedRecent = self.streetSuggestionsDataSource.recents[indexPath.row]
            self.mainViewDelegate?.loadPostionFromFavsRecents(selectedRecent)
        case 1:
            let selectedFavourite = self.streetSuggestionsDataSource.favourites[indexPath.row]
            self.mainViewDelegate?.loadPostionFromFavsRecents(selectedFavourite)
        default:
            break
        }
    }
}
