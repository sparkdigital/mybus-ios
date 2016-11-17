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
        
        //Set up title of controller (used by page menu item)
        self.title = result.emojiDescription()
        
        
        if result.busRouteType == MyBusRouteResultType.Single {
            //Build simple cell
        }else{
            //Build combinated cell
        }
        
        //set model to cell
        //add cell view to currentview
        
        
    }
    
    
}
