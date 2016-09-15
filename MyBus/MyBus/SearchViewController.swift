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
    func newBusRoad(mapBusRoad: MapBusRoad)
    func newResults(busSearchResult: BusSearchResult)
    func newOrigin(coordinate: CLLocationCoordinate2D, address: String)
    func newDestination(coordinate: CLLocationCoordinate2D, address: String)
    func newCompleteBusRoute(route: CompleteBusRoute)
}


class SearchViewController: UIViewController, UITableViewDelegate
{

    @IBOutlet weak var searchTableView: UITableView!
    
    var searchViewProtocol: MapBusRoadDelegate?
    var busResults: [String] = []
    var bestMatches: [String] = []
    var favourites: List<Location>?
    var roadResultList: [MapBusRoad] = []
    var streetSuggestionsDataSource: SearchDataSource!
    let progressNotification = ProgressHUD()

    // MARK: - View Lifecycle Methods

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.streetSuggestionsDataSource = SearchDataSource()
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = streetSuggestionsDataSource
  
        let view = UINib(nibName:"HeaderTableView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
        self.searchTableView.tableHeaderView = view;
    }

    override func viewDidAppear(animated: Bool) {
        // Create realm pointing to default file
        let realm = try! Realm()
        // Retrive favs locations for user
        favourites = realm.objects(User).first?.favourites

        self.streetSuggestionsDataSource.favourites = favourites

        self.searchTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
