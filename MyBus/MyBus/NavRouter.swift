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
    fileprivate let main: String = "Main"
    fileprivate let search: String = "Search"
    fileprivate let buses: String = "Buses"
    fileprivate let more: String = "More"

    //Storyboard view controller identifiers
    fileprivate let searchViewIdentifier: String = "SearchViewController"
    fileprivate let mapViewIdentifier: String = "MapViewController"
    fileprivate let ratesViewIdentifier: String = "BusesRatesViewController"
    fileprivate let informationViewIdentifier: String = "BusesInformationViewController"
    fileprivate let suggestionViewIdentifier: String = "SuggestionSearchViewController"
    fileprivate let searchContainerViewIdentifier: String = "SearchContainerViewController"
    fileprivate let busesResultsTableViewIdentifier: String = "BusesResultsTableVC"
    fileprivate let favoriteViewIdentifier: String = "FavoriteViewController"
    fileprivate let aboutUsViewIdentifier: String = "AboutUsViewController"
    fileprivate let moreViewIdentifier: String = "MoreViewController"
    fileprivate let termsViewIdentfier: String = "TermsViewController"

    //Method that receives a storyboard string identifier and returns a view controller object
    fileprivate func buildComponentVC(_ identifier: String, storyBoard: String) -> UIViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: storyBoard, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }

    func aboutUsController()->UIViewController {
        return self.buildComponentVC(self.aboutUsViewIdentifier, storyBoard: self.main)
    }

    func searchController()->UIViewController {
        return self.buildComponentVC(self.searchViewIdentifier, storyBoard: self.search)
    }

    func mapViewController()->UIViewController {
       return self.buildComponentVC(self.mapViewIdentifier, storyBoard: self.main)
    }

    func busesRatesController()->UIViewController {
        return self.buildComponentVC(self.ratesViewIdentifier, storyBoard: self.buses)
    }

    func busesInformationController()->UIViewController {
        return self.buildComponentVC(self.informationViewIdentifier, storyBoard: self.buses)
    }

    func suggestionController()->UIViewController {
        return self.buildComponentVC(self.suggestionViewIdentifier, storyBoard: self.search)
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
