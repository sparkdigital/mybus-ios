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
}

class MapViewModel {

    var origin: RoutePoint?
    var destiny: RoutePoint?

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
}


class MainViewController: UIViewController{

    //Reference to the container view
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var locateUserButton: UIBarButtonItem!

    @IBOutlet weak var searchToolbar: UIToolbar!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var mapSearchViewContainer: MapSearchViewContainer!
    @IBOutlet weak var mapSearchViewHeightConstraint: NSLayoutConstraint!

    //Temporary model
    var mapViewModel: MapViewModel!

    var mapViewController: MyBusMapController!
    var searchViewController: SearchViewController!
    var suggestionSearchViewController: SuggestionSearchViewController!

    var searchContainerViewController: SearchContainerViewController!

    var busesRatesViewController: BusesRatesViewController!
    var busesInformationViewController: BusesInformationViewController!
    var busesResultsTableViewController: BusesResultsTableViewController!

    var navRouter: NavRouter!

    //Reference to the currentViewController being shown
    weak var currentViewController: UIViewController?

    let progressNotification = ProgressHUD()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.navRouter = NavRouter()
        self.mapViewController =  self.navRouter.mapViewController() as! MyBusMapController
        self.searchViewController = self.navRouter.searchController() as! SearchViewController

        self.searchViewController.mainViewDelegate = self

        self.suggestionSearchViewController = self.navRouter.suggestionController() as! SuggestionSearchViewController
        self.searchContainerViewController = self.navRouter.searchContainerViewController() as! SearchContainerViewController

        self.busesRatesViewController = self.navRouter.busesRatesController() as! BusesRatesViewController
        self.busesInformationViewController = self.navRouter.busesInformationController() as! BusesInformationViewController

        self.currentViewController = mapViewController
        self.currentViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.view.addAutoPinnedSubview(self.currentViewController!.view, toView: self.containerView)

        self.mapSearchViewContainer.layer.borderColor = UIColor(red: 2/255, green: 136/255, blue: 209/255, alpha: 1).CGColor
        self.mapSearchViewContainer.layer.borderWidth = 8


        self.configureMapNavigationInfo()

        self.tabBar.delegate = self

        self.mapViewModel = MapViewModel()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.homeNavigationBar(mapViewModel)
    }
    
    //This method receives the old view controller to be replaced with the new controller
    func cycleViewController(oldVC: UIViewController, toViewController newVC: UIViewController) {

        //If it's triggered by the same button, dismiss action
        if oldVC == newVC {
            return
        }

        oldVC.willMoveToParentViewController(nil)
        self.addChildViewController(newVC)

        //Add new view to the container
        self.view.addAutoPinnedSubview(newVC.view, toView: self.containerView)


        newVC.view.alpha = 0
        newVC.view.layoutIfNeeded()

        UIView.animateWithDuration(0.5, animations: {
            newVC.view.alpha = 1.0
            oldVC.view.alpha = 0.0
            }, completion: {
                finished in

                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
                newVC.didMoveToParentViewController(self)
        })


    }

    func searchRoute(){
        if self.mapViewModel.hasOrigin && self.mapViewModel.hasDestiny {
            self.progressNotification.showLoadingNotification(self.view)
            SearchManager.sharedInstance.search(mapViewModel.origin!, destination: mapViewModel.destiny!, completionHandler: { (searchResult, error) in

                self.progressNotification.stopLoadingNotification(self.view)

                if let r: BusSearchResult = searchResult {
                    self.newResults(r)
                    let searchController: BusesResultsTableViewController = self.navRouter.busesResultsTableViewController() as! BusesResultsTableViewController

                    searchController.buses = r.busRouteOptions
                    self.navigationController?.pushViewController(searchController, animated: true)
                }else{
                    GenerateMessageAlert.generateAlert(self, title: "Error", message: error!.description)
                }
            })
        }else{
            let title = "Campos requeridos"
            let message = "Se requiere un origen y un destino para calcular la ruta"

            GenerateMessageAlert.generateAlert(self, title: title, message: message)

        }
    }

    func clearActiveSearch(){
        self.mapViewModel.clearModel()
        self.mapViewController.resetMapSearch()
        self.homeNavigationBar(self.mapViewModel)
    }

}

// MARK: Searchable protocol methods
extension MainViewController:Searchable{

    func initWithBasicSearch() {
        mapSearchViewContainer.loadBasicSearch()
        mapSearchViewContainer.presenter.setBarDelegate(self)
        updateSearchViewLayout(mapSearchViewContainer.presenter.preferredHeight())
    }

    func initWithComplexSearch(origin: RoutePoint?, destination: RoutePoint?) {
        mapSearchViewContainer.loadComplexSearch(origin, destination: destination)
        mapSearchViewContainer.presenter.setTextFieldDelegate(self)
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

}


// MARK: Tab Bar Delegate methods
extension MainViewController:UITabBarDelegate {

    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if (item.tag == 0){
            self.homeNavigationBar(self.mapViewModel)
            self.cycleViewController(self.currentViewController!, toViewController: mapViewController)
            self.currentViewController = mapViewController
            self.mapViewController.clearRechargePoints()
        }
        if (item.tag == 1){
            //self.toggleSearchViewContainer(true)
        }
        if (item.tag == 2){
            self.toggleSearchViewContainer(true)
            if let userLocation = self.mapViewController.mapView.userLocation {
                Connectivity.sharedInstance.getRechargeCardPoints(userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude) {
                    points, error in

                    if let chargePoints = points {
                        self.mapViewController.addRechargePoints(chargePoints)
                    } else {
                        GenerateMessageAlert.generateAlert(self, title: "Malas noticias", message: "No encontramos puntos de carga cercanos a tu ubicación")
                    }

                }
                if self.currentViewController != mapViewController {
                    self.cycleViewController(self.currentViewController!, toViewController: mapViewController)
                    self.currentViewController = mapViewController
                }
            } else {
                GenerateMessageAlert.generateAlert(self, title: "Tuvimos un problema 😿", message: "No pudimos obtener tu ubicación para buscar los puntos de carga cercanos")
            }
        }
        if (item.tag == 3){
            self.sectionNavigationBar("Recorridos")
            self.cycleViewController(self.currentViewController!, toViewController: busesInformationViewController)
            self.currentViewController = busesInformationViewController
            self.busesInformationViewController.searchViewProtocol = self
        }
        if (item.tag == 4){
            self.sectionNavigationBar("Tarifas")
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
        self.mapViewController.addBusLinesResults(busSearchResult)
        self.mapViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleViewController(self.currentViewController!, toViewController: self.mapViewController)
        self.currentViewController = self.mapViewController
    }

    func newOrigin(origin: CLLocationCoordinate2D, address: String) {
        self.mapViewController.addOriginPosition(origin, address: address)
    }

    func newOrigin(routePoint: RoutePoint) {
        self.mapViewController.addOriginPosition(routePoint.getLatLong(), address: routePoint.address)
        self.mapViewModel.origin = routePoint
    }

    func newDestination(destination: CLLocationCoordinate2D, address: String) {
        self.mapViewController.addDestinationPosition(destination, address : address)
    }

    func newDestination(routePoint: RoutePoint) {
        self.mapViewController.addDestinationPosition(routePoint.getLatLong(), address : routePoint.address)
        self.mapViewModel.destiny = routePoint
    }

    func newCompleteBusRoute(route: CompleteBusRoute) -> Void {
        self.homeNavigationBar(self.mapViewModel)
        self.mapViewController.displayCompleteBusRoute(route)
    }
    
    // TODO: Temporary solution until the location logic is refactored to another class
    func newOriginWithCurrentLocation() {
        self.newEndpointWithCurrentLocation(SearchType.Origin, handler: self.newOrigin)
    }
    
    // TODO: Temporary solution until the location logic is refactored to another class
    func newDestinationWithCurrentLocation() {
        self.newEndpointWithCurrentLocation(SearchType.Destiny, handler: self.newDestination)
    }
    
    private func newEndpointWithCurrentLocation(endpointType:SearchType, handler:(RoutePoint)->Void){
        
        guard let location = self.mapViewController.userLocation else {
            NSLog("Location Manager not enabled")
            return
        }
        
        Connectivity.sharedInstance.getAddressFromCoordinate(location.coordinate.latitude, longitude: location.coordinate.longitude) { (point, error) in
            
            if let p = point {
                handler(p)
                self.verifySearchStatus(self.mapViewModel)
                self.mapViewController.showUserLocation()
            }else{
                let title = "No sabemos donde es el \(endpointType.rawValue)"
                let message = "No pudimos resolver la dirección de \(endpointType.rawValue) ingresada"
                GenerateMessageAlert.generateAlert(self, title: title, message: message)
            }
            
        }
    }
}

// MARK: Custom Navigation bars extension
extension MainViewController {
    
    func homeNavigationBar(mapModel:MapViewModel){
        
        self.verifySearchStatus(mapModel)
        
        if mapViewModel.isEmpty() {
            self.logoNavigationBar()
        }else{
            self.searchNavigationBar()
        }
        
        self.toggleSearchViewContainer(true)
        self.cycleViewController(self.currentViewController!, toViewController: self.mapViewController)
        self.currentViewController = self.mapViewController
        
        self.tabBar.selectedItem = self.tabBar.items?[0]
    }
    
    func verifySearchStatus(mapModel:MapViewModel){
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
        
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.clearActiveSearch))
        cancelButton.tintColor = UIColor.lightGrayColor()
        
        let searchRouteButton = UIBarButtonItem(title: "Buscar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.searchRoute))
        searchRouteButton.tintColor = UIColor.lightGrayColor()
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = searchRouteButton
        
        self.navigationItem.title = "Buscar Ruta"
    }
    
    func sectionNavigationBar(title:String){
        self.navigationItem.titleView = nil
        self.navigationItem.title = title
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.backTapped) )
        backButton.image = UIImage(named:"arrow_back")
        backButton.tintColor = UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = nil
        
        self.toggleSearchViewContainer(false)
    }
    
    func toggleSearchViewContainer(show:Bool){
        self.mapSearchViewContainer.hidden = !show
    }
    
    func backTapped(){
        self.homeNavigationBar(self.mapViewModel)
        //self.mapViewController.clearRouteAnnotations()
    }
}
