//
//  CombinedRouteView.swift
//  MyBus
//
//  Created by Sebastian Fink on 11/17/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

class CombinedRouteView: UIView, RoutePresenterDelegate {

    //Constants
    private var nibId:String = "CombinedRouteView"
    private var viewHeight:CGFloat = 225
    
    //Xib Outlets
    @IBOutlet weak var lblBusLineNumber: UILabel!
    @IBOutlet weak var lblOriginAddress: UILabel!
    @IBOutlet weak var lblDestinationAddress: UILabel!
    @IBOutlet weak var lblCombinationOriginAddress: UILabel!
    @IBOutlet weak var lblCombinationDestinationAddress: UILabel!
    
    //Xib Attributes
    var routeResultModel: BusRouteResult? {
        didSet {
            reloadData()
        }
    }
    
    //Methods
    override init(frame: CGRect) {
        let rect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, viewHeight)
        super.init(frame: rect)
        xibSetup(nibId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup(nibId)
    }
    
    // MARK: RouterPresenterDelegate methods
    func reloadData() {
        
        guard let model = routeResultModel else {
            NSLog("[CombinedRouteView] RouteResult is nil. Not reloading view")
            return
        }
        
        guard let firstOption = model.busRoutes.first, let secondOption = model.busRoutes.last else {
            NSLog("[CombinedRouteView] No options to display. Not reloading view")
            return
        }
        
        //Combination header
        lblBusLineNumber.text = "\(firstOption.busLineName) → \(secondOption.busLineName)"
        
        //Start
        lblOriginAddress.text = "\(firstOption.startBusStopStreetName) \(firstOption.startBusStopStreetNumber)"
        lblDestinationAddress.text = "\(firstOption.destinationBusStopStreetName) \(firstOption.destinationBusStopStreetNumber)"
        
        //Combination
        lblCombinationOriginAddress.text = "\(secondOption.startBusStopStreetName) \(secondOption.startBusStopStreetNumber)"
        lblCombinationDestinationAddress.text = "\(secondOption.destinationBusStopStreetName) \(secondOption.destinationBusStopStreetNumber)"
        
       
    }
    
    func preferredHeight() -> CGFloat {
        return viewHeight
    }
    
}
