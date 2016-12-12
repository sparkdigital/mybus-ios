//
//  BusResultViewController.swift
//  MyBus
//
//  Created by Sebastian Fink on 11/17/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

class BusResultViewController: UIViewController {
    
    var busResultScrollView:UIScrollView!
    
    private var routeResultView:RoutePresenterDelegate?
    
    var routeResult:BusRouteResult! {
        didSet {
            self.reloadData()
        }
    }
    
    var roadResult:RoadResult! {
        didSet{
            self.updateRouteWithRoadInfo()
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
    
    
    private func reloadData(){
        
        guard let result = self.routeResult else {
            return
        }
        
        //clean up views
        self.view.clearViewSubviews()
        
        self.routeResultView = nil
        
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
        
        //Create and Setup ScrollView
        self.busResultScrollView = UIScrollView(frame: self.view.bounds)
        self.busResultScrollView.contentSize = CGSize(width: self.view.bounds.width, height: routeResultView!.preferredHeight())
        self.busResultScrollView.scrollEnabled = true
        self.busResultScrollView.bounces = false
        self.busResultScrollView.alwaysBounceVertical = false
        self.busResultScrollView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        
        //Add RouteResultView to scrollview
        self.view.addAutoPinnedSubview(routeResultView as! UIView, toView: self.busResultScrollView)
        
        //Add ScrollView to viewController's view
        self.view.addAutoPinnedSubview(busResultScrollView, toView: self.view)
    }
    
    private func updateRouteWithRoadInfo(){
        self.routeResultView?.roadResultModel = self.roadResult
    }
    
    
}
