//
//  SingleRouteView.swift
//  MyBus
//
//  Created by Sebastian Fink on 11/17/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

protocol RoutePresenterDelegate {
    var routeResultModel:BusRouteResult? { get set }
    func reloadData()
    func preferredHeight()->CGFloat
}


class SingleRouteView: UIView, RoutePresenterDelegate {
    
    //Constants
    private var nibId:String = "SingleRouteView"
    private var viewHeight:CGFloat = 135
    
    //Xib Outlets
    @IBOutlet weak var lblBusLineNumber: UILabel!
    @IBOutlet weak var lblOriginAddress: UILabel!
    @IBOutlet weak var lblDestinationAddress: UILabel!
   
    
    //Xib attributes
    var routeResultModel: BusRouteResult? {
        didSet{
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
            NSLog("[SingleRouteView] RouteResult is nil. Not reloading view")
            return
        }
        
        guard let busOption = model.busRoutes.first else {
            NSLog("[SingleRouteView] No option to display. Not reloading view")
            return
        }
        
        lblBusLineNumber.text = busOption.busLineName
        lblOriginAddress.text = "\(busOption.startBusStopStreetName) \(busOption.startBusStopStreetNumber)"
        lblDestinationAddress.text = "\(busOption.destinationBusStopStreetName) \(busOption.destinationBusStopStreetNumber)"
       
    }
    
    func preferredHeight() -> CGFloat {
       return viewHeight
    }

}
