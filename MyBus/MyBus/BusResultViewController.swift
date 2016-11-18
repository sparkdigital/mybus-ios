//
//  BusResultViewController.swift
//  MyBus
//
//  Created by Sebastian Fink on 11/17/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

class BusResultViewController: UIViewController {
    
    var routeResult:BusRouteResult! {
        didSet {
            self.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func reloadData(){
        
        guard let result = self.routeResult else {
            return
        }
        
        //clean up views
        self.view.clearViewSubviews()
        
        var routeResultView:RoutePresenterDelegate? = nil
        
        if result.busRouteType == MyBusRouteResultType.Single {
            //Build simple cell
            routeResultView = SingleRouteView(frame: self.view.bounds)
        }else{
            //Build combinated cell
            routeResultView = CombinedRouteView(frame: self.view.bounds)
        }
        
        //Set model
        routeResultView?.routeResultModel = result
        
        //Set up title of controller (used by page menu item)
        self.title = result.toStringDescription()
        
        //add cell view to currentview
        self.view.addAutoPinnedSubview(routeResultView as! UIView, toView: self.view)
       
    }
    
    
}
