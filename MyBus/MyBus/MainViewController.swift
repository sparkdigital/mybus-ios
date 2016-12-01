//
//  MainViewController.swift
//  MyBus
//
//  Created by Lisandro Falconi on 7/11/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol Searchable {
    func initWithBasicSearch()
    func initWithComplexSearch(origin: RoutePoint?, destination: RoutePoint?)
    func newOriginSearchRequest()
    func newDestinationSearchRequest()
    func invertSearch()
}

protocol MapViewModelDelegate {
    func endPointsInverted(from: RoutePoint?, to: RoutePoint?)
}

class MapViewModel {

    var origin: RoutePoint?
    var destiny: RoutePoint?

    var delegate: MapViewModelDelegate?

    var hasOrigin: Bool {
        return origin != nil
    }
    var hasDestiny: Bool {
        return destiny != nil
    }

    func clearModel(){
        origin = nil
        destiny = nil
    }

    func isEmpty()->Bool {
        return !hasOrigin && !hasDestiny
    }

    func invertEndpoints(){
        let tmpPoint: RoutePoint? = origin
        self.origin = destiny
        self.destiny = tmpPoint
        self.delegate?.endPointsInverted(origin, to: destiny)
    }
}


class MainViewController: UIViewController {

    //Reference to the container view
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var locateUserButton: UIBarButtonItem!

    @IBOutlet weak var searchToolbar: UIToolbar!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var mapSearchViewContainer: MapSearchViewContainer!
    @IBOutlet weak var mapSearchViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var menuTabBar: UITabBar!
    @IBOutlet weak var menuTabBarHeightConstraint: NSLayoutConstraint!
    let defaultTabBarHeight: CGFloat = 49

    //Temporary model
    var mapViewModel: MapViewModel!

    var mapViewController: MyBusMapController!
    var searchViewController: SearchViewController!
    var suggestionSearchViewController: SuggestionSearchViewController!

    var searchContainerViewController: SearchContainerViewController!
    var favoriteViewController: FavoriteViewController!
    var busesRatesViewController: BusesRatesViewController!
    var busesInformationViewController: BusesInformationViewController!
    var busesResultsTableViewController: BusesResultsTableViewController!

    var navRouter: NavRouter!

    //Reference to the currentViewController being shown
    weak var currentViewController: UIViewController?

    let progressNotification = ProgressHUD()
    var reachability: ReachabilityMyBus?
    
    let alertNetworkNotReachable = UIAlertController.init(title: Localization.getLocalizedString("Malas_Noticias"), message: Localization.getLocalizedString("No_Observamos"), preferredStyle: .ActionSheet)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navRouter = NavRouter()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)

        initMapModel()
        initTabBarControllers()
        setCurrentViewController()
        setupSearchViewContainer()
        setUpMapGestures()
        addDragDropMarkersObservers()
        addBusesResultsMenuStatusObservers()
        addReachabilityObserver()
        addAppBecameActiveObserver()        
    }

    func initMapModel() {
        self.mapViewModel = MapViewModel()
        self.mapViewModel.delegate = self
    }
    
    func setupSearchViewContainer(){
        self.mapSearchViewContainer.layer.borderColor = UIColor(red: 2/255, green: 136/255, blue: 209/255, alpha: 1).CGColor
        self.mapSearchViewContainer.layer.borderWidth = 8
    }

    func addDragDropMarkersObservers() {
        // Add observers
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateDraggedOrigin), name:MyBusEndpointNotificationKey.originChanged.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateDraggedDestination), name: MyBusEndpointNotificationKey.destinationChanged.rawValue, object: nil)
    }
    
    func addBusesResultsMenuStatusObservers(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(busesMenuDidExpand), name: BusesResultsMenuStatusNotification.Expanded.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(busesMenuDidCollapse), name: BusesResultsMenuStatusNotification.Collapsed.rawValue, object: nil)
    }

    func addReachabilityObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)
        let settingsAction = UIAlertAction(title: "Configuración", style: .Default) { (_) -> Void in
            let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.sharedApplication().openURL(url)
            }
        }

        alertNetworkNotReachable.addAction(settingsAction)
    }
    
    func addAppBecameActiveObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.startReachablity(_:)), name: "applicationDidBecomeActive", object: nil)
    }

    func setUpMapGestures() {
        // Double tapping zooms the map, so ensure that can still happen
        let doubleTap = UITapGestureRecognizer(target: self, action: nil)
        doubleTap.numberOfTapsRequired = 2
        self.mapViewController.mapView.addGestureRecognizer(doubleTap)

        // Delay single tap recognition until it is clearly not a double
        let singleLongTap = UILongPressGestureRecognizer(target: self, action: #selector(MainViewController.handleSingleLongTap(_:)))
        singleLongTap.requireGestureRecognizerToFail(doubleTap)
        self.mapViewController.mapView.addGestureRecognizer(singleLongTap)
    }

    func setCurrentViewController() {
        self.currentViewController = mapViewController
        self.currentViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.view.addAutoPinnedSubview(self.currentViewController!.view, toView: self.containerView)
    }

    func initTabBarControllers() {
        self.mapViewController =  self.navRouter.mapViewController() as! MyBusMapController
        self.searchViewController = self.navRouter.searchController() as! SearchViewController
        self.favoriteViewController = self.navRouter.favoriteController() as! FavoriteViewController
        self.suggestionSearchViewController = self.navRouter.suggestionController() as! SuggestionSearchViewController
        self.searchContainerViewController = self.navRouter.searchContainerViewController() as! SearchContainerViewController
        self.busesResultsTableViewController = self.navRouter.busesResultsTableViewController() as! BusesResultsTableViewController
        self.busesResultsTableViewController.mainViewDelegate = self

        self.busesRatesViewController = self.navRouter.busesRatesController() as! BusesRatesViewController
        self.busesInformationViewController = self.navRouter.busesInformationController() as! BusesInformationViewController
        
        self.tabBar.delegate = self

    }

    func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! ReachabilityMyBus
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            alertNetworkNotReachable.dismissViewControllerAnimated(true, completion: nil)
        } else {
            print("Network not reachable")
            alertNetworkNotReachable.dismissViewControllerAnimated(false, completion: nil)
            self.presentViewController(alertNetworkNotReachable, animated: true, completion: nil)
        }
    }

    func handleSingleLongTap(tap: UITapGestureRecognizer) {
        if (tap.state == .Ended) {
            NSLog("Long press Ended")
        } else if (tap.state == .Began) {
            self.mapViewController.mapView.showsUserLocation = true
            // Convert tap location (CGPoint) to geographic coordinates (CLLocationCoordinate2D)
            let tappedLocation = self.mapViewController.mapView.convertPoint(tap.locationInView(self.mapViewController.mapView), toCoordinateFromView: self.mapViewController.mapView)

            progressNotification.showLoadingNotification(self.view)

            Connectivity.sharedInstance.getAddressFromCoordinate(tappedLocation.latitude, longitude: tappedLocation.longitude) { (routePoint, error) in
                if let destination = routePoint {
                    if let _ = self.mapViewModel.origin {
                        self.newDestination(destination)
                    } else {
                        self.newOrigin(destination)
                    }
                    self.homeNavigationBar(self.mapViewModel)
                }
                self.progressNotification.stopLoadingNotification(self.view)
            }
        }

    }

    private func getPropertyChangedFromNotification(notification: NSNotification) -> AnyObject {
        let userInfo: [String : AnyObject] = notification.userInfo as! [String:AnyObject]
        return userInfo[MyBusMarkerAnnotationView.kPropertyChangedDescriptor]!
    }

    func updateDraggedOrigin(notification: NSNotification) {
        NSLog("Origin dragged detected")
        let draggedOrigin: MyBusMarker = self.getPropertyChangedFromNotification(notification) as! MyBusMarker
        let location = draggedOrigin.coordinate
        progressNotification.showLoadingNotification(self.view)

        Connectivity.sharedInstance.getAddressFromCoordinate(location.latitude, longitude: location.longitude) { (routePoint, error) in
            if let newOrigin = routePoint {
                self.newOrigin(newOrigin)
                self.homeNavigationBar(self.mapViewModel)
            } else if let origin = self.mapViewModel.origin {
                self.newOrigin(origin)
                self.homeNavigationBar(self.mapViewModel)
            }
            self.progressNotification.stopLoadingNotification(self.view)
        }
    }

    func updateDraggedDestination(notification: NSNotification) {
        NSLog("Destination dragged detected")
        let draggedDestination: MyBusMarker = self.getPropertyChangedFromNotification(notification) as! MyBusMarker
        let location = draggedDestination.coordinate
        progressNotification.showLoadingNotification(self.view)

        Connectivity.sharedInstance.getAddressFromCoordinate(location.latitude, longitude: location.longitude) { (routePoint, error) in
            if let newDestination = routePoint {
                self.newDestination(newDestination)
                self.homeNavigationBar(self.mapViewModel)
            } else if let destination = self.mapViewModel.destiny {
                self.newDestination(destination)
                self.homeNavigationBar(self.mapViewModel)
            }
            self.progressNotification.stopLoadingNotification(self.view)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        startReachablity(nil)
        homeNavigationBar(mapViewModel)
    }

    func startReachablity(note: NSNotification?) {
        do {
            reachability = try ReachabilityMyBus.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
        }

        do {
            try reachability?.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }

    //This method receives the old view controller to be replaced with the new controller
    func cycleViewController(oldVC: UIViewController, toViewController newVC: UIViewController) {

        //If it's triggered by the same button, dismiss action
        if oldVC == newVC {
            return
        }

        oldVC.willMoveToParentViewController(nil)
        self.addChildViewController(newVC)
        newVC.view.translatesAutoresizingMaskIntoConstraints = false
        //Add new view to the container
        self.view.addAutoPinnedSubview(newVC.view, toView: self.containerView)


        newVC.view.alpha = 0
        newVC.view.layoutIfNeeded()
        
        newVC.view.alpha = 1.0
        oldVC.view.alpha = 0.0
        
        oldVC.view.removeFromSuperview()
        oldVC.removeFromParentViewController()
        newVC.didMoveToParentViewController(self)

    }

    func hideTabBar() {
        self.menuTabBar.layer.zPosition = -1
        self.menuTabBar.hidden = true
        self.menuTabBarHeightConstraint.constant = 0
    }

    func showTabBar() {
        self.menuTabBar.layer.zPosition = 0
        self.menuTabBar.hidden = false
        self.menuTabBarHeightConstraint.constant = defaultTabBarHeight
    }

    func searchRoute(){
        if self.mapViewModel.hasOrigin && self.mapViewModel.hasDestiny {
            self.progressNotification.showLoadingNotification(self.view)
            SearchManager.sharedInstance.search(mapViewModel.origin!, destination: mapViewModel.destiny!, completionHandler: { (searchResult, error) in
                
                DBManager.sharedInstance.addRecent(self.mapViewModel.origin!)
                DBManager.sharedInstance.addRecent(self.mapViewModel.destiny!)
                self.progressNotification.stopLoadingNotification(self.view)

                if let r: BusSearchResult = searchResult {
                    if r.hasRouteOptions {
                        self.hideTabBar()
                        self.addBackNavItem(Localization.getLocalizedString("Rutas_Encontradas"))

                        self.busesResultsTableViewController.loadBuses(r)
                        self.cycleViewController(self.currentViewController!, toViewController: self.busesResultsTableViewController)
                        self.currentViewController = self.busesResultsTableViewController
                    }else{
                        GenerateMessageAlert.generateAlert(self, title: Localization.getLocalizedString("Malas_Noticias"), message: Localization.getLocalizedString("Lamentablemente_Consulta"))
                    }
                }else{
                    GenerateMessageAlert.generateAlert(self, title: Localization.getLocalizedString("Error"), message: Localization.getLocalizedString("No_Conexion"))
                }
            })
        }else{
            let title = Localization.getLocalizedString("Campos_Requeridos")
            let message = Localization.getLocalizedString("Se_Requiere")

            GenerateMessageAlert.generateAlert(self, title: title, message: message)

        }
    }

    func clearActiveSearch(){
        self.mapViewModel.clearModel()
        self.mapViewController.resetMapSearch()
        SearchManager.sharedInstance.currentSearch = nil
        self.homeNavigationBar(self.mapViewModel)
    }

}

extension MainViewController:MapViewModelDelegate {
    func endPointsInverted(from: RoutePoint?, to: RoutePoint?) {

        //Do nothing if both endpoints are nil
        if mapViewModel.isEmpty() {
            return
        }

        //Else, just invert the points
        self.newOrigin(from)
        self.newDestination(to)

        //update search view
        verifySearchStatus(mapViewModel)

        //If there's already a current search, fire the searchRoute method again

        if let _ = SearchManager.sharedInstance.currentSearch {
            self.searchRoute()
            return
        }

        return


    }
}


// MARK: Searchable protocol methods
extension MainViewController:Searchable{

    func initWithBasicSearch() {
        mapSearchViewContainer.loadBasicSearch()
        mapSearchViewContainer.presenter.setSearchDelegate(self)
        updateSearchViewLayout(mapSearchViewContainer.presenter.preferredHeight())
    }

    func initWithComplexSearch(origin: RoutePoint?, destination: RoutePoint?) {
        mapSearchViewContainer.loadComplexSearch(origin, destination: destination)
        mapSearchViewContainer.presenter.setSearchDelegate(self)
        updateSearchViewLayout(mapSearchViewContainer.presenter.preferredHeight())
    }

    func newOriginSearchRequest(){
        self.createSearchRequest(SearchType.Origin)
    }
    func newDestinationSearchRequest(){
        self.createSearchRequest(SearchType.Destiny)
    }

    func updateSearchViewLayout(preferredHeight: CGFloat){
        mapSearchViewHeightConstraint.constant = preferredHeight
        mapSearchViewContainer.updateConstraints()
        mapSearchViewContainer.layoutIfNeeded()
    }

    func createSearchRequest(type: SearchType){
        let searchController: SearchContainerViewController = self.navRouter.searchContainerViewController() as! SearchContainerViewController
        searchController.busRoadDelegate = self

        searchController.searchType = type

        self.navigationController?.pushViewController(searchController, animated: true)
    }

    func invertSearch() {
        self.mapViewModel.invertEndpoints()
    }

}


// MARK: Tab Bar Delegate methods
extension MainViewController:UITabBarDelegate {

    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if (item.tag == 0){
            self.homeNavigationBar(self.mapViewModel)
            self.cycleViewController(self.currentViewController!, toViewController: mapViewController)
            self.currentViewController = mapViewController
            self.mapViewController.toggleRechargePoints(nil)
        }
        if (item.tag == 1){
            self.sectionNavigationBar(Localization.getLocalizedString(Localization.getLocalizedString("Favoritos")))
            self.cycleViewController(self.currentViewController!, toViewController: favoriteViewController)
            self.currentViewController = favoriteViewController
            let add = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(self.addFavoritePlace))
            add.tintColor = UIColor.whiteColor()
            self.navigationItem.rightBarButtonItem = add
        }
        if (item.tag == 2){
            self.clearActiveSearch()
            self.homeNavigationBar(self.mapViewModel)
            self.tabBar.selectedItem = self.tabBar.items?[2]
            if let userLocation = self.mapViewController.mapView.userLocation {
                progressNotification.showLoadingNotification(self.view)
                Connectivity.sharedInstance.getRechargeCardPoints(userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude) {
                    points, error in

                    if let chargePoints = points {
                        self.mapViewController.toggleRechargePoints(chargePoints)
                    } else {
                        GenerateMessageAlert.generateAlert(self, title: Localization.getLocalizedString("Malas_Noticias"), message: Localization.getLocalizedString("No_Encontramos"))
                    }
                    self.progressNotification.stopLoadingNotification(self.view)

                }
                if self.currentViewController != mapViewController {
                    self.cycleViewController(self.currentViewController!, toViewController: mapViewController)
                    self.currentViewController = mapViewController
                }
            } else {
                GenerateMessageAlert.generateAlert(self, title: Localization.getLocalizedString("Tuvimos_Problema"), message: Localization.getLocalizedString("No_Pudimos"))
            }
        }
        if (item.tag == 3){
            self.sectionNavigationBar(Localization.getLocalizedString("Recorridos"))
            self.cycleViewController(self.currentViewController!, toViewController: busesInformationViewController)
            self.currentViewController = busesInformationViewController
            self.busesInformationViewController.searchViewProtocol = self
        }
        if (item.tag == 4){
            self.sectionNavigationBar(Localization.getLocalizedString("Tarifas"))
            self.cycleViewController(self.currentViewController!, toViewController: busesRatesViewController)
            self.currentViewController = busesRatesViewController
        }
    }
}

// MARK: UISearchBarDelegate protocol methods
extension MainViewController:UISearchBarDelegate {

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        //Load searchviewcontroller
        searchBar.resignFirstResponder()
        self.createSearchRequest(SearchType.Origin)
    }

}


// MARK: MapBusRoadDelegate protocol methods
extension MainViewController:MapBusRoadDelegate {

    //func newBusRoad(mapBusRoad: MapBusRoad) {
    //Now is no longer needed may be in the future with a new flow yes
    //self.mapViewController.addBusRoad(mapBusRoad)
    //}

    func newResults(busSearchResult: BusSearchResult) {
        self.showTabBar()

        if busSearchResult.hasRouteOptions {
            self.mapViewController.addBusLinesResults(busSearchResult.busRouteOptions, preselectedRouteIndex: busSearchResult.indexSelected!)
        }else{
            GenerateMessageAlert.generateAlert(self, title: Localization.getLocalizedString("Malas_Noticias"), message:Localization.getLocalizedString("Lamentablemente_Consulta"))
        }

        self.mapViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleViewController(self.currentViewController!, toViewController: self.mapViewController)
        self.currentViewController = self.mapViewController
    }

    func newOrigin(routePoint: RoutePoint?) {
        self.mapViewController.updateOrigin(routePoint)
        self.mapViewModel.origin = routePoint
    }

    func newDestination(routePoint: RoutePoint?) {
        self.mapViewController.updateDestination(routePoint)
        self.mapViewModel.destiny = routePoint
    }

    func newCompleteBusRoute(route: CompleteBusRoute) -> Void {
        self.clearActiveSearch()
        self.mapViewController.updateCompleteBusRoute(route)
    }

}

// MARK: Custom Navigation bars extension
extension MainViewController {

    func homeNavigationBar(mapModel: MapViewModel){

        self.verifySearchStatus(mapModel)

        if mapViewModel.isEmpty() {
            self.logoNavigationBar()
        }else{
            self.searchNavigationBar()
        }
        self.showTabBar()
        self.toggleSearchViewContainer(true)
        self.cycleViewController(self.currentViewController!, toViewController: self.mapViewController)
        self.currentViewController = self.mapViewController

        self.tabBar.selectedItem = self.tabBar.items?[0]
    }

    func verifySearchStatus(mapModel: MapViewModel){
        //SearchViewContainer Logic

        if mapModel.isEmpty() {
            self.initWithBasicSearch()
        }else{
            self.initWithComplexSearch(mapModel.origin, destination:mapModel.destiny)
        }
    }

    func logoNavigationBar(){
        let titleView = UINib(nibName:"TitleMainView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
        self.navigationItem.titleView = titleView
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
    }

    func searchNavigationBar(){
        self.navigationItem.titleView = nil

        let cancelButton = UIBarButtonItem(title: Localization.getLocalizedString("Cancelar"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.clearActiveSearch))
        cancelButton.tintColor = UIColor.lightGrayColor()

        let searchRouteButton = UIBarButtonItem(title: Localization.getLocalizedString("Buscar"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.searchRoute))
        searchRouteButton.tintColor = UIColor.lightGrayColor()

        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.leftBarButtonItem!.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = searchRouteButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()

        self.navigationItem.title = Localization.getLocalizedString("Buscar_Ruta")
    }

    func sectionNavigationBar(title: String){
        addBackNavItem(title)
        self.toggleSearchViewContainer(false)
    }

    func addBackNavItem(title: String) {
        self.navigationItem.titleView = nil
        self.navigationItem.title = title

        let backButton = UIBarButtonItem(title: " ", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.backTapped) )
        backButton.image = UIImage(named:"arrow_back")
        backButton.tintColor = UIColor.whiteColor()

        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = nil
    }

    func toggleSearchViewContainer(show: Bool){
        self.mapSearchViewContainer.hidden = !show
        mapSearchViewHeightConstraint.constant = !show ? 0 : mapSearchViewContainer.presenter.preferredHeight()
    }

    func backTapped(){
        if(self.navigationItem.title == Localization.getLocalizedString("Rutas_Encontradas")){
            self.mapViewModel.clearModel()
            self.mapViewController.resetMapSearch()
        }
        self.homeNavigationBar(self.mapViewModel)
    }

    func addFavoritePlace(){
        self.favoriteViewController.addFavoritePlace()
    }
    
    func busesMenuDidExpand(notification:NSNotification){
        UIView.animateWithDuration(0.4) {
            self.hideTabBar()
            self.toggleSearchViewContainer(false)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.view.layoutIfNeeded()
        }
    }
    
    func busesMenuDidCollapse(notification:NSNotification){
        UIView.animateWithDuration(0.4) {
            self.showTabBar()
            self.toggleSearchViewContainer(true)
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.view.layoutIfNeeded()
        }
    }
    
}
