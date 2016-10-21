//
//  SearchSuggestionViewController.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 9/30/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit
import Mapbox
import RealmSwift

protocol SuggestionProtocol {
    var name: String { get }
    func getImage() -> UIImage
}

class FavoriteSuggestion: SuggestionProtocol {
    var name: String = ""
    var 📍: Location

    init(name: String, location: Location){
        self.name = name
        self.📍 = location
    }

    func getImage() -> UIImage {
        return UIImage(named: "favorite")!
    }
}

class SearchSuggestion: SuggestionProtocol {
    var name: String = ""

    init(name: String){
        self.name = name
    }

    func getImage() -> UIImage {
        return UIImage(named: "search")!
    }
}

class RecentSuggestion: SuggestionProtocol {
    var name: String = ""
    var 📍: RoutePoint

    init(name: String, point: RoutePoint){
        self.name = name
        self.📍 = point
    }

    func getImage() -> UIImage {
        return UIImage(named: "recent")!
    }
}

class SuggestionSearchViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate
{
    @IBOutlet weak var searchSuggestionTableView: UITableView!

    var bestMatches: [SuggestionProtocol] = []
    var suggestionsDataSource: SearchSuggestionsDataSource!
    var searchBarController: UISearchController!
    var mainViewDelegate: MainViewDelegate?

    var searchBar: UISearchBar?
    // MARK: - View Lifecycle Methods

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.suggestionsDataSource = SearchSuggestionsDataSource()
        self.searchSuggestionTableView.delegate = self
        self.searchSuggestionTableView.dataSource = suggestionsDataSource
    }

    override func viewDidAppear(animated: Bool) {
        self.suggestionsDataSource.bestMatches = bestMatches
        self.searchSuggestionTableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBar = searchBar
        self.suggestionsDataSource.bestMatches = self.applyFilter(searchText)
        self.searchSuggestionTableView.reloadData()
    }

    func applyFilter(searchText: String) -> [SuggestionProtocol] {
        self.bestMatches = []
        let recents = DBManager.sharedInstance.getRecents().filter(NSPredicate(format: "address CONTAINS[c] %@", searchText))
        for recent in recents {
            self.bestMatches.append(RecentSuggestion(name: recent.address, point: recent))
        }

        //TODO Refactor favorites collections -> use RoutePoint instead Location
        let favs = DBManager.sharedInstance.getFavourites().filter(NSPredicate(format: "name CONTAINS[c] %@", searchText))
        for fav in favs {
            self.bestMatches.append(FavoriteSuggestion(name: "\(fav.streetName) \(fav.houseNumber)", location: fav))
        }

        //filter streets
        Connectivity.sharedInstance.getStreetNames(forName: searchText) { (streets, error) in
            if error == nil {
                for street in streets! {
                    self.bestMatches.append(SearchSuggestion(name: street))
                }
            }
        }
        //filter tourist places
        let touristPlaces = Configuration.suggestedPlaces().filter{($0.name.lowercaseString).containsString(searchText.lowercaseString)}
        for place in touristPlaces {
            self.bestMatches.append(place)
        }

        return self.bestMatches
    }

    func cleanSearch() {
        self.bestMatches = []
        self.suggestionsDataSource.bestMatches = self.bestMatches
        self.searchSuggestionTableView.reloadData()
    }

    func  tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let result: SuggestionProtocol = self.bestMatches[indexPath.row] {
            if let recentSelected = result as? RecentSuggestion {
                self.mainViewDelegate?.loadPostionFromFavsRecents(recentSelected.📍)
            } else if let placeSelected = result as? SuggestedPlace {
                let 📍 = RoutePoint()
                📍.latitude = placeSelected.location.latitude
                📍.longitude = placeSelected.location.longitude
                📍.address = placeSelected.address != nil ? placeSelected.address! : placeSelected.name
                self.mainViewDelegate?.loadPostionFromFavsRecents(📍)
            } else if let favSelected = result as? FavoriteSuggestion {
                //TODO
            } else {
                self.searchBar?.text = "\(result.name) "
            }
        }
    }
}
