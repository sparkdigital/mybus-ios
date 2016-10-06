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

public enum SearchFilterType {
    case Search,Favorite,Tourist
}

class SuggestionSearchViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate
{
    @IBOutlet weak var searchSuggestionTableView: UITableView!
    
    var bestMatches: [(String,SearchFilterType)] = []
    var suggestionsDataSource: SearchSuggestionsDataSource!
    var searchBarController: UISearchController!
    
    
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
        self.suggestionsDataSource.bestMatches = self.applyFilter(searchText)
        self.searchSuggestionTableView.reloadData()
    }
    
    func applyFilter(searchText: String) -> [(String,SearchFilterType)] {
         self.bestMatches = []
        Connectivity.sharedInstance.getStreetNames(forName: searchText) { (streets, error) in
            if error == nil {
                for street in streets! {
                    self.bestMatches.append(street, SearchFilterType.Search)
                }
            }
        }
        //TODO: load favorites and Tourist places
        
        return self.bestMatches
    }
    
    func cleanSearch() {
        self.bestMatches = []
        self.suggestionsDataSource.bestMatches = self.bestMatches
        self.searchSuggestionTableView.reloadData()
    }
    
    func  tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //do something
    }
}