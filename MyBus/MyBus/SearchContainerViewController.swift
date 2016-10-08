//
//  SearchContainerViewController.swift
//  MyBus
//
//  Created by Sebastian Fink on 9/26/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

enum SearchType:String {
    case Origin  = "Origen"
    case Destiny = "Destino"
}


class SearchContainerViewController: UIViewController {

    @IBOutlet weak var addressLocationSearchBar: UISearchBar!
    @IBOutlet weak var searchContainerView: UIView!
    
    var shortcutsViewController:SearchViewController!
    var suggestionViewController:SuggestionSearchViewController!
    
    weak var currentViewController:UIViewController!
    var searchType:SearchType = SearchType.Origin
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let router = NavRouter()
                
        self.shortcutsViewController = router.searchController() as! SearchViewController
        self.suggestionViewController = router.suggestionController() as! SuggestionSearchViewController
        
        self.currentViewController = shortcutsViewController
        self.currentViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController)
        self.view.addAutoPinnedSubview(currentViewController!.view, toView: searchContainerView)
        
        
        self.addressLocationSearchBar.delegate = self
        
        //Navigation Item configuration
        let cancelButtonItem = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(goBackToMap))
        cancelButtonItem.tintColor = UIColor.lightGrayColor()
        
        self.navigationItem.leftBarButtonItem = cancelButtonItem
        self.navigationItem.title = "Buscar \(self.searchType.rawValue)"
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func cycleViewController(oldVC:UIViewController, toViewController newVC:UIViewController){
        
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
   
    
}



