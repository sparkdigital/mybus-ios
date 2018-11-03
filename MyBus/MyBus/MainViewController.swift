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
    func initWithComplexSearch(_ origin: RoutePoint?, destination: RoutePoint?)
    func newOriginSearchRequest()
    func newDestinationSearchRequest()
    func invertSearch()
}

protocol MapViewModelDelegate {
    func endPointsInverted(_ from: RoutePoint?, to: RoutePoint?)
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
    var busesInformationViewController: BusesInformationViewController!
    var busesResultsTableViewController: BusesResultsTableViewController!
    var moreViewController: MoreViewController!

    var navRouter: NavRouter!

    //Control variable for some Reachability flows
    var alertPresented: Bool = false


    //Reference to the currentViewController being shown
    weak var currentViewController: UIViewController?

    let progressNotification = ProgressHUD()
    var reachability: ReachabilityMyBus = ReachabilityMyBus()!

    let alertNetworkNotReachable = UIAlertController.init(title: Localization.getLocalizedString("Malas_Noticias"), message: Localization.getLocalizedString("No_Observamos"), preferredStyle: .actionSheet)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navRouter = NavRouter()

        NotificationCenter.default.removeObserver(self)

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
        self.mapSearchViewContainer.layer.borderColor = UIColor(red: 2/255, green: 136/255, blue: 209/255, alpha: 1).cgColor
        self.mapSearchViewContainer.layer.borderWidth = 8
    }

    func addDragDropMarkersObservers() {
        // Add observers
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(updateDraggedOrigin), name:NSNotification.Name(rawValue: MyBusEndpointNotificationKey.originChanged.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateDraggedDestination), name: NSNotification.Name(rawValue: MyBusEndpointNotificationKey.destinationChanged.rawValue), object: nil)
    }

    func addBusesResultsMenuStatusObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(busesMenuDidExpand), name: NSNotification.Name(rawValue: BusesResultsMenuStatusNotification.Expanded.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(busesMenuDidCollapse), name: NSNotification.Name(rawValue: BusesResultsMenuStatusNotification.Collapsed.rawValue), object: nil)
    }

    func addReachabilityObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)

        let settingsAction = UIAlertAction(title: "Configuración", style: .default) { (_) -> Void in
            let settingsUrl = URL(string: UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.openURL(url)
                self.alertPresented = false
            }
        }

        alertNetworkNotReachable.addAction(settingsAction)
    }

    func addAppBecameActiveObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.startReachablity(_:)), name: NSNotification.Name(rawValue: "applicationDidBecomeActive"), object: nil)
    }

    func setUpMapGestures() {
        // Double tapping zooms the map, so ensure that can still happen
        let doubleTap = UITapGestureRecognizer(target: self, action: nil)
        doubleTap.numberOfTapsRequired = 2
        self.mapViewController.mapView.addGestureRecognizer(doubleTap)

        // Delay single tap recognition until it is clearly not a double
        let singleLongTap = UILongPressGestureRecognizer(target: self, action: #selector(MainViewController.handleSingleLongTap(_:)))
        singleLongTap.require(toFail: doubleTap)
        self.mapViewController.mapView.addGestureRecognizer(singleLongTap)
    }

    func setCurrentViewController() {
        self.currentViewController = mapViewController
        self.currentViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(self.currentViewController!)
        self.view.addAutoPinnedSubview(self.currentViewController!.view, toView: self.containerView)
    }

    func initTabBarControllers() {
        self.mapViewController =  self.navRouter.mapViewController() as? MyBusMapController
        self.searchViewController = self.navRouter.searchController() as? SearchViewController
        self.favoriteViewController = self.navRouter.favoriteController() as? FavoriteViewController
        self.suggestionSearchViewController = self.navRouter.suggestionController() as? SuggestionSearchViewController
        self.searchContainerViewController = self.navRouter.searchContainerViewController() as? SearchContainerViewController
        self.busesResultsTableViewController = self.navRouter.busesResultsTableViewController() as? BusesResultsTableViewController
        self.busesResultsTableViewController.mainViewDelegate = self
        self.busesInformationViewController = self.navRouter.busesInformationController() as? BusesInformationViewController
        self.moreViewController = self.navRouter.moreViewController() as? MoreViewController

        self.tabBar.delegate = self

    }

    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! ReachabilityMyBus
        if reachability.isReachable {
            internetIsReachable(reachability: reachability)
        } else {
            internetIsNotReachable()
        }
    }
    
    func internetIsNotReachable() {
        print("Network not reachable")
        if alertNetworkNotReachable.view.window == nil && !alertPresented {
            self.present(alertNetworkNotReachable, animated: true, completion: nil)
            alertPresented = true
        }
    }
    
    func internetIsReachable(reachability: ReachabilityMyBus) {
        if reachability.isReachableViaWiFi {
            print("Reachable via WiFi")
        } else {
            print("Reachable via Cellular")
        }
        alertNetworkNotReachable.dismiss(animated: true, completion: nil)
        alertPresented = false
    }

    @objc func handleSingleLongTap(_ tap: UITapGestureRecognizer) {
        if (tap.state == .ended) {
            NSLog("Long press Ended")
        } else if (tap.state == .began) {
            self.mapViewController.mapView.showsUserLocation = true
            // Convert tap location (CGPoint) to geographic coordinates (CLLocationCoordinate2D)
            let tappedLocation = self.mapViewController.mapView.convert(tap.location(in: self.mapViewController.mapView), toCoordinateFrom: self.mapViewController.mapView)

            progressNotification.showLoadingNotification(self.view)

            if let annotations = self.mapViewController.mapView.annotations {
                if( annotations.count > 1 ){
                    self.progressNotification.stopLoadingNotification(self.view)
                    let alert = UIAlertController(title: Localization.getLocalizedString("Borrar_Busqueda"), message: Localization.getLocalizedString("Confirmar_Borrado_Busqueda"), preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: Localization.getLocalizedString("Ok"), style: UIAlertAction.Style.default) { (_) -> Void in

                        self.progressNotification.showLoadingNotification(self.view)
                        self.defineOriginDestination(tappedLocation.latitude, longitude: tappedLocation.longitude)})
                    alert.addAction(UIAlertAction(title: Localization.getLocalizedString("Cancelar"), style: UIAlertAction.Style.cancel) { (_) -> Void in})
                    self.present(alert, animated: true, completion: nil)
                }else{
                    self.defineOriginDestination(tappedLocation.latitude, longitude: tappedLocation.longitude)
                }
            }
            else{
                self.defineOriginDestination(tappedLocation.latitude, longitude: tappedLocation.longitude)
            }
        }
    }

    fileprivate func defineOriginDestination(_ latitude: Double, longitude: Double){
        LoggingManager.sharedInstance.logEvent(LoggableAppEvent.ENDPOINT_FROM_LONGPRESS)
        Connectivity.sharedInstance.getAddressFromCoordinate(latitude, longitude: longitude) { (routePoint, error) in
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

    fileprivate func getPropertyChangedFromNotification(_ notification: Notification) -> AnyObject {
        let userInfo: [String : AnyObject] = notification.userInfo as! [String:AnyObject]
        return userInfo[MyBusMarkerAnnotationView.kPropertyChangedDescriptor]!
    }

    @objc func updateDraggedOrigin(_ notification: Notification) {
        NSLog("Origin dragged detected")
        let draggedOrigin: MyBusMarker = self.getPropertyChangedFromNotification(notification) as! MyBusMarker
        let location = draggedOrigin.coordinate
        progressNotification.showLoadingNotification(self.view)

        LoggingManager.sharedInstance.logEvent(LoggableAppEvent.MARKER_DRAGGED)

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

    @objc func updateDraggedDestination(_ notification: Notification) {
        NSLog("Destination dragged detected")
        let draggedDestination: MyBusMarker = self.getPropertyChangedFromNotification(notification) as! MyBusMarker
        let location = draggedDestination.coordinate
        progressNotification.showLoadingNotification(self.view)

        LoggingManager.sharedInstance.logEvent(LoggableAppEvent.MARKER_DRAGGED)

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startReachablity(nil)
        homeNavigationBar(mapViewModel)
    }

    @objc func startReachablity(_ note: Notification?) {
        if reachability.isReachable {
            internetIsReachable(reachability: reachability)
        } else {
            internetIsNotReachable()
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }

    //This method receives the old view controller to be replaced with the new controller
    func cycleViewController(_ oldVC: UIViewController, toViewController newVC: UIViewController) {

        //If it's triggered by the same button, dismiss action
        if oldVC == newVC {
            return
        }

        oldVC.willMove(toParent: nil)
        self.addChild(newVC)
        newVC.view.translatesAutoresizingMaskIntoConstraints = false
        //Add new view to the container
        self.view.addAutoPinnedSubview(newVC.view, toView: self.containerView)


        newVC.view.alpha = 0
        newVC.view.layoutIfNeeded()

        newVC.view.alpha = 1.0
        oldVC.view.alpha = 0.0

        oldVC.view.removeFromSuperview()
        oldVC.removeFromParent()
        newVC.didMove(toParent: self)

    }

    func hideTabBar() {
        self.menuTabBar.layer.zPosition = -1
        self.menuTabBar.isHidden = true
        self.menuTabBarHeightConstraint.constant = 0
    }

    func showTabBar() {
        self.menuTabBar.layer.zPosition = 0
        self.menuTabBar.isHidden = false
        self.menuTabBarHeightConstraint.constant = defaultTabBarHeight
    }

    @objc func searchRoute(){
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

    @objc func clearActiveSearch(){
        self.mapViewModel.clearModel()
        self.mapViewController.resetMapSearch()
        SearchManager.sharedInstance.currentSearch = nil
        self.homeNavigationBar(self.mapViewModel)
    }

}

extension MainViewController:MapViewModelDelegate {
    func endPointsInverted(_ from: RoutePoint?, to: RoutePoint?) {

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

    func initWithComplexSearch(_ origin: RoutePoint?, destination: RoutePoint?) {
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

    func updateSearchViewLayout(_ preferredHeight: CGFloat){
        mapSearchViewHeightConstraint.constant = preferredHeight
        mapSearchViewContainer.updateConstraints()
        mapSearchViewContainer.layoutIfNeeded()
    }

    func createSearchRequest(_ type: SearchType){
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

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (item.tag == 0){
            self.homeNavigationBar(self.mapViewModel)
            self.cycleViewController(self.currentViewController!, toViewController: mapViewController)
            self.currentViewController = mapViewController
            self.mapViewController.toggleRechargePoints(nil)
            LoggingManager.sharedInstance.logSection(LoggableAppSection.MAP)
        }
        if (item.tag == 1){
            self.sectionNavigationBar(Localization.getLocalizedString(Localization.getLocalizedString("Favoritos")))
            self.cycleViewController(self.currentViewController!, toViewController: favoriteViewController)
            self.currentViewController = favoriteViewController
            let add = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(self.addFavoritePlace))
            add.tintColor = UIColor.white
            self.navigationItem.rightBarButtonItem = add
            LoggingManager.sharedInstance.logSection(LoggableAppSection.FAVOURITES)
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
            LoggingManager.sharedInstance.logSection(LoggableAppSection.RECHARGE)
        }
        if (item.tag == 3){
            self.sectionNavigationBar(Localization.getLocalizedString("Recorridos"))
            self.cycleViewController(self.currentViewController!, toViewController: busesInformationViewController)
            self.currentViewController = busesInformationViewController
            self.busesInformationViewController.searchViewProtocol = self
            LoggingManager.sharedInstance.logSection(LoggableAppSection.ROUTES)
        }
        if (item.tag == 4){
            self.logoNavigationBar()
            self.toggleSearchViewContainer(false)
            self.cycleViewController(self.currentViewController!, toViewController: moreViewController)
            self.currentViewController = moreViewController
        }
    }
}

// MARK: UISearchBarDelegate protocol methods
extension MainViewController:UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
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

    func newResults(_ busSearchResult: BusSearchResult) {
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

    func newOrigin(_ routePoint: RoutePoint?) {
        self.mapViewController.updateOrigin(routePoint)
        self.mapViewModel.origin = routePoint
    }

    func newDestination(_ routePoint: RoutePoint?) {
        self.mapViewController.updateDestination(routePoint)
        self.mapViewModel.destiny = routePoint
    }

    func newCompleteBusRoute(_ route: CompleteBusRoute) -> Void {
        self.clearActiveSearch()
        self.mapViewController.updateCompleteBusRoute(route)
    }

}

// MARK: Custom Navigation bars extension
extension MainViewController {

    func homeNavigationBar(_ mapModel: MapViewModel){

        self.verifySearchStatus(mapModel)

        let moreSelected: Bool = (self.tabBar.items?.last == self.tabBar.selectedItem)

        if moreSelected {
            self.logoNavigationBar()
            self.toggleSearchViewContainer(false)
            self.showTabBar()
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }else{

            if mapViewModel.isEmpty() {
                self.logoNavigationBar()
            }else{
                self.searchNavigationBar()
            }
            self.showTabBar()
            self.navigationController?.setNavigationBarHidden(false, animated: false)

            self.toggleSearchViewContainer(true)
            self.cycleViewController(self.currentViewController!, toViewController: self.mapViewController)
            self.currentViewController = self.mapViewController

            self.tabBar.selectedItem = self.tabBar.items?[0]
        }

    }

    func verifySearchStatus(_ mapModel: MapViewModel){
        //SearchViewContainer Logic

        if mapModel.isEmpty() {
            self.initWithBasicSearch()
        }else{
            self.initWithComplexSearch(mapModel.origin, destination:mapModel.destiny)
        }
    }

    func logoNavigationBar(){
        let titleView = UINib(nibName:"TitleMainView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        self.navigationItem.titleView = titleView
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
    }

    func adaptivePresentationStyleForPresentationController(_ controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

    func searchNavigationBar(){
        self.navigationItem.titleView = nil

        let cancelButton = UIBarButtonItem(title: Localization.getLocalizedString("Cancelar"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.clearActiveSearch))
        cancelButton.tintColor = UIColor.lightGray

        let searchRouteButton = UIBarButtonItem(title: Localization.getLocalizedString("Buscar"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.searchRoute))
        searchRouteButton.tintColor = UIColor.lightGray

        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.leftBarButtonItem!.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = searchRouteButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white

        self.navigationItem.title = Localization.getLocalizedString("Buscar_Ruta")
    }

    func sectionNavigationBar(_ title: String){
        addBackNavItem(title)
        self.toggleSearchViewContainer(false)
    }

    func addBackNavItem(_ title: String) {
        self.navigationItem.titleView = nil
        self.navigationItem.title = title

        let backButton = UIBarButtonItem(title: " ", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.backTapped) )
        backButton.image = UIImage(named:"arrow_back")
        backButton.tintColor = UIColor.white

        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = nil
    }

    func toggleSearchViewContainer(_ show: Bool){
        self.mapSearchViewContainer.isHidden = !show
        mapSearchViewHeightConstraint.constant = !show ? 0 : mapSearchViewContainer.presenter.preferredHeight()
    }

    @objc func backTapped(){
        if(self.navigationItem.title == Localization.getLocalizedString("Rutas_Encontradas")){
            self.mapViewModel.clearModel()
            self.mapViewController.resetMapSearch()
        }
        self.homeNavigationBar(self.mapViewModel)
    }

    @objc func addFavoritePlace(){
        self.favoriteViewController.addFavoritePlace()
    }

    @objc func busesMenuDidExpand(_ notification: Notification){
        UIView.animate(withDuration: 0.4, animations: {
            self.hideTabBar()
            self.toggleSearchViewContainer(false)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.view.layoutIfNeeded()
        })
    }

    @objc func busesMenuDidCollapse(_ notification: Notification){
        UIView.animate(withDuration: 0.4, animations: {
            self.showTabBar()
            self.toggleSearchViewContainer(true)
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.view.layoutIfNeeded()
        })
    }

}
