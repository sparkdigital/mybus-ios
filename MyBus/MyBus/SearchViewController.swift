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
    func newCompleteBusRoute(route: CompleteBusRoute)
    func newOrigin(routePoint: RoutePoint?)
    func newDestination(routePoint: RoutePoint?)
}

protocol MainViewDelegate: class {
    func loadPositionMainView()
    func loadPositionFromFavsRecents(position: RoutePoint)
}

class SearchViewController: UIViewController, UITableViewDelegate
{
    
    //Variable with a hardcoded height (usually is around this value)
    let kSearchBarNavBarHeight:CGFloat = 140.0
    let kMinimumKeyboardHeight:CGFloat = 216.0 + 140.0
    
    //Control variable to see if we're using the search textfield or not
    var isSearching:Bool = false
    
    @IBOutlet weak var searchTableView: UITableView!

    var mainViewDelegate: MainViewDelegate?
    var busResults: [String] = []
    var bestMatches: [String] = []
    var favourites: List<RoutePoint>?
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

        
        //Custom code
        
        // Listen for keyboard changes (if it's showing or hiding)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWasShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWasHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        //You could initialize nonetheless the table footer with a custom height
        self.setupTableViewFooter(kMinimumKeyboardHeight)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func tappedCurrentLocation(){
        LoggingManager.sharedInstance.logEvent(LoggableAppEvent.ENDPOINT_GPS_SEARCH)
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
            LoggingManager.sharedInstance.logEvent(LoggableAppEvent.ENDPOINT_FROM_RECENTS)
            let selectedRecent = self.streetSuggestionsDataSource.recents[indexPath.row]
            self.mainViewDelegate?.loadPositionFromFavsRecents(selectedRecent)
        case 1:
            LoggingManager.sharedInstance.logEvent(LoggableAppEvent.ENDPOINT_FROM_FAVORITES)
            let selectedFavourite = self.streetSuggestionsDataSource.favourites[indexPath.row]
            self.mainViewDelegate?.loadPositionFromFavsRecents(selectedFavourite)
        default:
            break
        }
    }
    
    // MARK: Keyboard was shown or hidden
    func keyboardWasShown(sender:NSNotification){
        self.isSearching = true
        
        guard let info: NSDictionary = sender.userInfo else {
            NSLog("SearchCountry - No user info found in notification")
            return
        }
        
        guard let value: NSValue = info.valueForKey(UIKeyboardFrameBeginUserInfoKey) as? NSValue else {
            NSLog("SearchCountry - No frame found for keyboard in userInfo")
            return
        }
        
        //Get the current keyboard size (I guess it varies across devices)
        let keyboardSize: CGSize = value.CGRectValue().size
        self.setupTableViewFooter(keyboardSize.height + kSearchBarNavBarHeight)
        
    }
    
    // Setup an empty footer
    func keyboardWasHidden(sender:NSNotification){
        self.isSearching = false
        self.setupTableViewFooter(0.0)
    }
    
    private func setupTableViewFooter(height:CGFloat){
        if height > 0.0 {
            self.searchTableView.tableFooterView = UIView(frame: CGRectMake(0.0,0.0,self.view.frame.width,height))
        }else{
            self.searchTableView.tableFooterView = UIView(frame:CGRectZero)
        }
    }
}
