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
import DZNEmptyDataSet

protocol SuggestionProtocol {
    var name: String { get }
    func getImage() -> UIImage
    func getPoint() -> RoutePoint
}

class FavoriteSuggestion: SuggestionProtocol {
    var name: String = ""
    var 📍: RoutePoint

    init(name: String, location: RoutePoint){
        self.name = name
        self.📍 = location
    }

    func getImage() -> UIImage {
        return UIImage(named: "favorite")!
    }

    func getPoint() -> RoutePoint {
        return 📍
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

    func getPoint() -> RoutePoint {
        return RoutePoint()
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

    func getPoint() -> RoutePoint {
        return 📍
    }
}

class SuggestionSearchViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    @IBOutlet weak var searchSuggestionTableView: UITableView!

    //Boolean variable that keeps track when a user taps on a suggestion to give more control on displaying the EmptyDataset legend
    var aSuggestionWasSelected: Bool = false
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


        self.searchSuggestionTableView.emptyDataSetSource = self
        self.searchSuggestionTableView.emptyDataSetDelegate = self
        // A little trick for removing the cell separators
        self.searchSuggestionTableView.tableFooterView = UIView()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.suggestionsDataSource.bestMatches = bestMatches
        self.searchSuggestionTableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBar = searchBar
        self.suggestionsDataSource.bestMatches = self.applyFilter(searchText)
        self.searchSuggestionTableView.reloadData()
    }

    func applyFilter(_ searchText: String) -> [SuggestionProtocol] {
        self.bestMatches = []

        if let recents = DBManager.sharedInstance.getRecents() {
            let filteredRecents = recents.filter(NSPredicate(format: "address CONTAINS[c] %@", searchText))
            for recent in filteredRecents {
                self.bestMatches.append(RecentSuggestion(name: recent.address, point: recent))
            }
        }

        //TODO Refactor favorites collections -> use RoutePoint instead Location
        if let favs = DBManager.sharedInstance.getFavourites() {
            let filteredFavs = favs.filter(NSPredicate(format: "name CONTAINS[c] %@", searchText))
            for fav in filteredFavs {
                self.bestMatches.append(FavoriteSuggestion(name: fav.address, location: fav))
            }
        }

        //filter streets
        Connectivity.sharedInstance.getStreetNames(forName: searchText) { (streets, error) in
            if let streets = streets {
                for street in streets {
                    self.bestMatches.append(SearchSuggestion(name: street))
                }
            }
        }
        //filter tourist places
        let touristPlaces = Configuration.suggestedPlaces().filter{($0.name.lowercased()).contains(searchText.lowercased())}
        for place in touristPlaces {
            self.bestMatches.append(place)
        }

        return self.bestMatches
    }

    func cleanSearch() {
        self.bestMatches = []
        self.suggestionsDataSource.bestMatches = self.bestMatches
        self.searchSuggestionTableView.reloadData()
        self.aSuggestionWasSelected = false
    }

    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        if self.bestMatches.count > indexPath.row {
            let result: SuggestionProtocol = self.bestMatches[indexPath.row]
            if let recentSelected = result as? RecentSuggestion {
                LoggingManager.sharedInstance.logEvent(LoggableAppEvent.ENDPOINT_FROM_RECENTS)
                self.mainViewDelegate?.loadPositionFromFavsRecents(recentSelected.getPoint())
            } else if let placeSelected = result as? SuggestedPlace {
                self.mainViewDelegate?.loadPositionFromFavsRecents(placeSelected.getPoint())
            } else if let favSelected = result as? FavoriteSuggestion {
                LoggingManager.sharedInstance.logEvent(LoggableAppEvent.ENDPOINT_FROM_FAVORITES)
                self.mainViewDelegate?.loadPositionFromFavsRecents(favSelected.getPoint())
            } else {
                self.searchBar?.text = "\(result.name) "
            }
        }

        self.aSuggestionWasSelected = true
    }

    //MARK: DZNEmptyDataSet setup methods

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: Localization.getLocalizedString("Sin_Resultados_Titulo"))
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ]
        return NSAttributedString(string: Localization.getLocalizedString("Sin_Resultados"), attributes: attributes)
    }

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return !aSuggestionWasSelected
    }
}
