//
//  NavRouter.swift
//  MyBus
//
//  Created by Julieta Gonzalez Poume on 9/29/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import UIKit

class NavRouter {

    //story board ids
    private let main: String = "Main"
    private let search: String = "Search"
    private let buses: String = "Buses"
    private let more:String = "More"

    //Storyboard view controller identifiers
    private let searchViewIdentifier: String = "SearchViewController"
    private let mapViewIdentifier: String = "MapViewController"
    private let ratesViewIdentifier: String = "BusesRatesViewController"
    private let informationViewIdentifier: String = "BusesInformationViewController"
    private let suggestionViewIdentifier: String = "SuggestionSearchViewController"
    private let suggestionsViewIdentifier: String = "SearchSuggestionsVC"
    private let searchContainerViewIdentifier: String = "SearchContainerViewController"
    private let busesResultsTableViewIdentifier: String = "BusesResultsTableVC"
    private let favoriteViewIdentifier: String = "FavoriteViewController"
    private let aboutUsViewIdentifier: String = "AboutUsViewController"
    private let moreViewIdentifier:String = "MoreViewController"
    private let termsViewIdentfier:String = "TermsViewController"

    //Method that receives a storyboard string identifier and returns a view controller object
    private func buildComponentVC(identifier: String, storyBoard: String) -> UIViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: storyBoard, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(identifier)
    }
    
    func aboutUsController()->UIViewController {
        return self.buildComponentVC(self.aboutUsViewIdentifier, storyBoard: self.main)
    }

    func searchController()->UIViewController {
        return self.buildComponentVC(self.searchViewIdentifier, storyBoard: self.main)
    }

    func mapViewController()->UIViewController {
       return self.buildComponentVC(self.mapViewIdentifier, storyBoard: self.main)
    }

    func busesRatesController()->UIViewController {
        return self.buildComponentVC(self.ratesViewIdentifier, storyBoard: self.main)
    }

    func busesInformationController()->UIViewController {
        return self.buildComponentVC(self.informationViewIdentifier, storyBoard: self.main)
    }

    func suggestionController()->UIViewController {
        return self.buildComponentVC(self.suggestionViewIdentifier, storyBoard: self.main)
    }

    func suggestionsViewController()->UIViewController{
        return self.buildComponentVC(self.suggestionsViewIdentifier, storyBoard: self.search)
    }

    func searchContainerViewController()->UIViewController {
        return self.buildComponentVC(self.searchContainerViewIdentifier, storyBoard: self.search)
    }

    func busesResultsTableViewController() -> UIViewController {
        return self.buildComponentVC(self.busesResultsTableViewIdentifier, storyBoard: self.buses)
    }

    func favoriteController()->UIViewController {
        return self.buildComponentVC(self.favoriteViewIdentifier, storyBoard: self.main)
    }
    
    func moreViewController()->UIViewController {
        return self.buildComponentVC(self.moreViewIdentifier, storyBoard: self.more)
    }
    
    func termsViewController()->UIViewController {
        return self.buildComponentVC(self.termsViewIdentfier, storyBoard: self.more)
    }

}
