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
    func initWithComplexSearch()
}


class MainViewController: UIViewController{
    
    //Reference to the container view
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var locateUserButton: UIBarButtonItem!

    @IBOutlet weak var searchToolbar: UIToolbar!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var mapSearchViewContainer:MapSearchViewContainer!
    @IBOutlet weak var mapSearchViewHeightConstraint: NSLayoutConstraint!


    var mapViewController: MyBusMapController!
    var searchViewController: SearchViewController!
    var suggestionSearchViewController: SuggestionSearchViewController!
    
    var searchContainerViewController:SearchContainerViewController!
    
    var busesRatesViewController: BusesRatesViewController!
    var busesInformationViewController: BusesInformationViewController!
    var navRouter: NavRouter!

    //Reference to the currentViewController being shown
    weak var currentViewController: UIViewController?

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
       
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //SearchViewContainer Logic
        self.initWithBasicSearch()
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

    //self.searchViewController.searchViewProtocol = self
    
    func toggleSearchViewContainer(show:Bool){
        self.mapSearchViewContainer.hidden = !show
    }
    
    
    func setNavigation(Title: String){
        self.navigationItem.titleView = nil
        self.navigationItem.title = Title
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.backTapped))
        backButton.image = UIImage(named:"arrow_back")
        backButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = backButton
    }

    func backTapped(){
        self.toggleSearchViewContainer(true)
        self.cycleViewController(self.currentViewController!, toViewController: self.mapViewController)
        self.currentViewController = self.mapViewController
        self.mapViewController.clearRouteAnnotations()
        configureMapNavigationInfo()
    }
    
    func configureMapNavigationInfo(){
        let titleView = UINib(nibName:"TitleMainView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
        self.navigationItem.titleView = titleView
        self.navigationItem.leftBarButtonItem = nil
        self.tabBar.selectedItem = tabBar.items?[0]        
    }
}

extension MainViewController:Searchable{
    
    func initWithBasicSearch() {
        mapSearchViewContainer.loadBasicSearch()
        mapSearchViewContainer.presenter.setBarDelegate(self)
        updateSearchViewLayout(mapSearchViewContainer.presenter.preferredHeight())
    }
    
    func initWithComplexSearch() {
        mapSearchViewContainer.loadComplexSearch()
        mapSearchViewContainer.presenter.setTextFieldDelegate(self)
        updateSearchViewLayout(mapSearchViewContainer.presenter.preferredHeight())
    }
    
    func updateSearchViewLayout(preferredHeight:CGFloat){
        mapSearchViewHeightConstraint.constant = preferredHeight
        mapSearchViewContainer.updateConstraints()
        mapSearchViewContainer.layoutIfNeeded()
    }
   
}


// MARK: Tab Bar Delegate methods
extension MainViewController:UITabBarDelegate {
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if (item.tag == 0){
            self.configureMapNavigationInfo()
            self.toggleSearchViewContainer(true)
            self.mapViewController.clearRechargePoints()
            self.cycleViewController(self.currentViewController!, toViewController: mapViewController)
            self.currentViewController = mapViewController
        }
        if (item.tag == 1){
            self.toggleSearchViewContainer(true)
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
            self.toggleSearchViewContainer(false)
            self.cycleViewController(self.currentViewController!, toViewController: busesInformationViewController)
            self.currentViewController = busesInformationViewController
            self.busesInformationViewController.searchViewProtocol = self
            self.setNavigation("Recorridos")
        }
        if (item.tag == 4){
            self.toggleSearchViewContainer(false)
            self.cycleViewController(self.currentViewController!, toViewController: busesRatesViewController)
            self.currentViewController = busesRatesViewController
            self.setNavigation("Tarifas")
        }
    }

    
}

// MARK: UISearchBarDelegate protocol methods
extension MainViewController:UISearchBarDelegate {
   
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        //Load searchviewcontroller
        searchBar.resignFirstResponder()
        let searchController:SearchContainerViewController = self.navRouter.searchContainerViewController() as! SearchContainerViewController
        
        //TODO: Debe variar segun el estado del modelo...
        searchController.searchType = SearchType.Origin
        self.navigationController?.pushViewController(searchController, animated: true)
    }
    
}


// MARK: UITextField delegate protocol methods
extension MainViewController:UITextFieldDelegate {
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
    
    func newDestination(destination: CLLocationCoordinate2D, address: String) {
        self.mapViewController.addDestinationPosition(destination, address : address)
    }
    
    
    func newCompleteBusRoute(route: CompleteBusRoute) -> Void {
        self.cycleViewController(self.currentViewController!, toViewController: mapViewController)
        self.currentViewController = mapViewController
        self.mapViewController.displayCompleteBusRoute(route)
    }
}

extension MainViewController:MainViewDelegate{
    
    func loadPositionMainView() {
        self.cycleViewController(self.currentViewController!, toViewController: self.mapViewController)
        self.currentViewController = self.mapViewController
        self.mapViewController.showUserLocation()
    }
}