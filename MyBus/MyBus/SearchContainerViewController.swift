//
//  SearchContainerViewController.swift
//  MyBus
//
//  Created by Sebastian Fink on 9/26/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

class SearchContainerViewController: UIViewController {

    @IBOutlet weak var addressLocationSearchBar: UISearchBar!
    
    @IBOutlet weak var searchContainerView: UIView!
    
    var currentVC:UIViewController!
    
    weak var suggestionsViewController:SearchSuggestionsViewController!
    weak var searchShortcuts:SearchViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let router = NavRouter()
        
        // Do any additional setup after loading the view.
        suggestionsViewController = router.suggestionsViewController() as! SearchSuggestionsViewController
        searchShortcuts = router.searchController() as! SearchViewController
        
        currentVC = searchShortcuts
        currentVC?.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentVC)
        self.addSubview(currentVC!.view, toView: searchContainerView)
       
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
        self.addSubview(newVC.view, toView: self.searchContainerView)
        
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
    
    private func addSubview(subview:UIView, toView parentView:UIView){
        parentView.addSubview(subview)
        
        var viewBindingsDict = [String:AnyObject]()
        viewBindingsDict["subView"] = subview
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
    
    
    /*
     //Action triggered by segment control
     @IBAction func showComponent(sender: UISegmentedControl) {
     
     let sceneIdentifier:String = sender.selectedSegmentIndex == 0 ? kComponentAIdentifier :kComponentBIdentifier
     let vc:UIViewController = self.buildComponentVC(sceneIdentifier)
     vc.view.translatesAutoresizingMaskIntoConstraints = false
     self.cycleViewController(self.currentViewController!, toViewController: vc)
     self.currentViewController = vc
     
     }
     */

}
