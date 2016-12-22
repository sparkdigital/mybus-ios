//
//  SearchContainerViewController.swift
//  MyBus
//
//  Created by Sebastian Fink on 9/26/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

enum SearchType: String {
    case Origin  = "Origen"
    case Destiny = "Destino"
}


class SearchContainerViewController: UIViewController {

    @IBOutlet weak var addressLocationSearchBar: UISearchBar!
    @IBOutlet weak var searchContainerView: UIView!

    var busRoadDelegate: MapBusRoadDelegate?

    var shortcutsViewController: SearchViewController!
    var suggestionViewController: SuggestionSearchViewController!

    weak var currentViewController: UIViewController!
    var searchType: SearchType = SearchType.Origin
    let progressNotification = ProgressHUD()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let router = NavRouter()

        self.shortcutsViewController = router.searchController() as! SearchViewController
        self.shortcutsViewController.mainViewDelegate = self

        self.suggestionViewController = router.suggestionController() as! SuggestionSearchViewController
        self.suggestionViewController.mainViewDelegate = self

        self.currentViewController = shortcutsViewController
        self.currentViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController)
        self.view.addAutoPinnedSubview(currentViewController!.view, toView: searchContainerView)
        
        self.addressLocationSearchBar.delegate = self
        self.addressLocationSearchBar.backgroundImage = UIImage()

        //Navigation Item configuration
        let cancelButtonItem = UIBarButtonItem(title:  Localization.getLocalizedString("Cancelar"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(goBackToMap))
        cancelButtonItem.tintColor = UIColor.whiteColor()

        self.navigationItem.leftBarButtonItem = cancelButtonItem
        self.navigationItem.title = "Buscar \(self.searchType.rawValue)"

        var barPlaceholder: String = ""
        if searchType == SearchType.Origin {
            barPlaceholder = Localization.getLocalizedString("Desde_Buscar")
        }else {
            barPlaceholder = Localization.getLocalizedString("Hacia_Buscar")
        }

        self.addressLocationSearchBar.placeholder = barPlaceholder

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.addressLocationSearchBar.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func cycleViewController(oldVC: UIViewController, toViewController newVC: UIViewController){

        if oldVC == newVC {
            return
        }

        oldVC.willMoveToParentViewController(nil)
        self.addChildViewController(newVC)


        //Add new view to the container
        self.view.addAutoPinnedSubview(newVC.view, toView: self.searchContainerView)

        newVC.view.alpha = 0
        newVC.view.layoutIfNeeded()

        UIView.animateWithDuration(0.5, animations: {
            newVC.view.alpha = 1.0
            oldVC.view.alpha = 0.0
            },
            completion:{ finished in
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
                newVC.didMoveToParentViewController(self)
        })

    }

    func goBackToMap(){
        self.navigationController?.popViewControllerAnimated(true)
    }

}


// MARK: UISearchBarDelegate protocol methods
extension SearchContainerViewController:UISearchBarDelegate {

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){

        let charCount = searchText.characters.count

        if charCount < 1 {
            //All cleared
            self.cycleViewController(self.currentViewController!, toViewController: self.shortcutsViewController)
            self.currentViewController = self.shortcutsViewController

            //Should clear suggestions search
            self.suggestionViewController.cleanSearch()

        }else if charCount > 0 {

            self.cycleViewController(self.currentViewController!, toViewController: self.suggestionViewController)
            self.currentViewController = self.suggestionViewController

            self.suggestionViewController.searchBar(self.addressLocationSearchBar, textDidChange: searchText)

        }
    } // called when text changes (including clear)

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {

        if let searchTerm: String = searchBar.text, let count: Int = searchTerm.characters.count where count > 0 {
            
            self.progressNotification.showLoadingNotification(self.view)
            
            if self.suggestionViewController.aSuggestionWasSelected {
                LoggingManager.sharedInstance.logEvent(LoggableAppEvent.ENDPOINT_FROM_SUGGESTION)
            }
            
            Connectivity.sharedInstance.getCoordinateFromAddress(searchTerm, completionHandler: { (point, error) in

                self.progressNotification.stopLoadingNotification(self.view)

                if let p = point {
                    if self.searchType == SearchType.Origin {
                        self.busRoadDelegate?.newOrigin(p)
                    }else{
                        self.busRoadDelegate?.newDestination(p)
                    }
                    self.goBackToMap()
                }else{
                    let title =  Localization.getLocalizedString(String.localizedStringWithFormat(NSLocalizedString("No_Sabemos", comment: "No_Sabemos") , self.searchType.rawValue))
                    let message = Localization.getLocalizedString(String.localizedStringWithFormat(NSLocalizedString("No_Sabemos", comment: "No_Pudimos_Resolver") , self.searchType.rawValue))

                    GenerateMessageAlert.generateAlert(self, title: title, message: message)

                }

            })

        }else {
            let message = Localization.getLocalizedString(String.localizedStringWithFormat(NSLocalizedString("El_Campo", comment: "El campo") , self.searchType.rawValue))
            GenerateMessageAlert.generateAlert(self, title: Localization.getLocalizedString("No_Sabemos_Que"), message: message)
        }
    }
}


extension SearchContainerViewController:MainViewDelegate{

    func loadPositionMainView() {

        
        LocationManager.sharedInstance.startUpdatingWithCompletionHandler { (location, error) in
            
            if let _ = error {
                let title =  Localization.getLocalizedString(String.localizedStringWithFormat(NSLocalizedString("No_Sabemos", comment: "No_Sabemos") , self.searchType.rawValue))
                let message = Localization.getLocalizedString("No_Pudimos")
                GenerateMessageAlert.generateAlert(self, title: title, message: message)
                return
            }
            
            NSLog("Location found!")
            
            self.progressNotification.showLoadingNotification(self.view)
            
            Connectivity.sharedInstance.getAddressFromCoordinate(location!.coordinate.latitude, longitude: location!.coordinate.longitude) { (point, error) in
                
                self.progressNotification.stopLoadingNotification(self.view)
                
                if let p = point {
                    
                    if self.searchType == SearchType.Origin {
                        self.busRoadDelegate?.newOrigin(p)
                    }else{
                        self.busRoadDelegate?.newDestination(p)
                    }
                    
                    return self.goBackToMap()
                    
                }else{
                    let title =  Localization.getLocalizedString(String.localizedStringWithFormat(NSLocalizedString("No_Sabemos", comment: "No_Sabemos") , self.searchType.rawValue))
                    let message = Localization.getLocalizedString("No_Pudimos")
                    GenerateMessageAlert.generateAlert(self, title: title, message: message)
                }
            }
           
        }
        
    }

    func loadPositionFromFavsRecents(position: RoutePoint) {
        if self.searchType == SearchType.Origin {
            self.busRoadDelegate?.newOrigin(position)
        }else{
            self.busRoadDelegate?.newDestination(position)
        }
        self.goBackToMap()
    }
}
