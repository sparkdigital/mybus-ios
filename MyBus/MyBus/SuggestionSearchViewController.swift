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

        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if let result: SuggestionProtocol = self.bestMatches[indexPath.row] {
            if let recentSelected = result as? RecentSuggestion {
                self.mainViewDelegate?.loadPositionFromFavsRecents(recentSelected.getPoint())
            } else if let placeSelected = result as? SuggestedPlace {
                self.mainViewDelegate?.loadPositionFromFavsRecents(placeSelected.getPoint())
            } else if let favSelected = result as? FavoriteSuggestion {
                self.mainViewDelegate?.loadPositionFromFavsRecents(favSelected.getPoint())
            } else {
                self.searchBar?.text = "\(result.name) "
            }
        }
    }
    
    
    
    //MARK: DZNEmptyDataSet setup methods
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: Localization.getLocalizedString("Sin_Resultados_Titulo"))
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes: [String : AnyObject] = [
            NSForegroundColorAttributeName: UIColor.lightGrayColor()
        ]
        return NSAttributedString(string: Localization.getLocalizedString("Sin_Resultados"), attributes: attributes)
    }
    
    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
        return true
    }
}
