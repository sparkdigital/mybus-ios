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
    var roadResultModel: RoadResult? { get set }
    func reloadData()
    func updateViewWithRoadInfo()
    func preferredHeight()->CGFloat
}


class SingleRouteView: UIView, RoutePresenterDelegate {
    
    //Constants
    private var nibId:String = "SingleRouteView"
    private var viewHeight:CGFloat = 135
    
    //Xib Outlets
    @IBOutlet weak var lblOriginAddress: UILabel!
    @IBOutlet weak var lblDestinationAddress: UILabel!
    @IBOutlet weak var lblTravelDistance:UILabel!
    @IBOutlet weak var lblTravelTime:UILabel!
    @IBOutlet weak var lblWalkDistanceToOrigin:UILabel!
    @IBOutlet weak var lblWalkDistanceToDestination:UILabel!
    @IBOutlet weak var destinationToOriginHeightConstraint:NSLayoutConstraint!
   
    
    //Xib attributes
    var routeResultModel: BusRouteResult? {
        didSet{
            reloadData()
        }
    }
    
    var roadResultModel: RoadResult? {
        didSet{
            updateViewWithRoadInfo()
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
        
        lblOriginAddress.text = "\(busOption.startBusStopStreetName) \(busOption.startBusStopStreetNumber)"
        lblDestinationAddress.text = "\(busOption.destinationBusStopStreetName) \(busOption.destinationBusStopStreetNumber)"
       
    }
    
    func updateViewWithRoadInfo(){
    }
    
    func preferredHeight() -> CGFloat {
       return viewHeight
    }

}
