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
    fileprivate var nibId: String = "CombinedRouteView"
    fileprivate var viewHeight: CGFloat = 250

    //Xib Outlets
    @IBOutlet weak var lblOriginAddress: UILabel!
    @IBOutlet weak var lblDestinationAddress: UILabel!
    @IBOutlet weak var lblCombinationOriginAddress: UILabel!
    @IBOutlet weak var lblCombinationDestinationAddress: UILabel!
    @IBOutlet weak var lblTravelDistance: UILabel!
    @IBOutlet weak var lblTravelTime: UILabel!
    @IBOutlet weak var lblWalkDistanceToOrigin: UILabel!
    @IBOutlet weak var lblWalkDistanceToIntermediateStop: UILabel!
    @IBOutlet weak var lblWalkDistanceToDestination: UILabel!
    @IBOutlet weak var firstDestinationToOriginHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var destinationToIntermediateStopHeightConstraint: NSLayoutConstraint!

    //Xib Attributes
    var routeResultModel: BusRouteResult? {
        didSet {
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
        let rect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: viewHeight)
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

        //Start
        lblOriginAddress.text = "\(firstOption.startBusStopStreetName) \(firstOption.startBusStopStreetNumber)"
        lblDestinationAddress.text = "\(firstOption.destinationBusStopStreetName) \(firstOption.destinationBusStopStreetNumber)"

        //Combination
        lblCombinationOriginAddress.text = "\(secondOption.startBusStopStreetName) \(secondOption.startBusStopStreetNumber)"
        lblCombinationDestinationAddress.text = "\(secondOption.destinationBusStopStreetName) \(secondOption.destinationBusStopStreetNumber)"


    }

    func updateViewWithRoadInfo(){
        guard let roadModel = roadResultModel else {
            NSLog("[CombinedRouteView] RoadResult is nil. Not updating view")
            return
        }

        lblTravelDistance.text = roadModel.formattedTravelDistance()
        lblTravelDistance.alpha = 1.0
        lblTravelTime.text = roadModel.formattedTravelTime()
        lblTravelTime.alpha = 1.0


        let walkDistanceToOrigin: Double = roadModel.walkingRoutes.first?.distance ?? 0.0
        let walkDistanceCombination: Double = self.routeResultModel?.combinationDistance ?? 0.0
        let walkDistanceToDestination: Double = roadModel.walkingRoutes.last?.distance ?? 0.0


        UIView.animate(withDuration: 0.2, animations: {
            if walkDistanceToOrigin < 100.0 {
                self.lblWalkDistanceToOrigin.alpha = 0
                self.lblWalkDistanceToOrigin.text = ""
                self.firstDestinationToOriginHeightConstraint.constant = 13
            }else{
                self.lblWalkDistanceToOrigin.alpha = 1
                self.lblWalkDistanceToOrigin.text = "Desde origen: \(roadModel.formattedWalkingDistance(walkDistanceToOrigin))"
                self.firstDestinationToOriginHeightConstraint.constant = 23
            }

            if walkDistanceCombination < 100.0 {
                self.lblWalkDistanceToIntermediateStop.alpha = 0
                self.lblWalkDistanceToIntermediateStop.text = ""
                self.destinationToIntermediateStopHeightConstraint.constant = 13
            }else{
                self.lblWalkDistanceToIntermediateStop.alpha = 1
                self.lblWalkDistanceToIntermediateStop.text = "Distancia a parada: \(roadModel.formattedWalkingDistance(walkDistanceCombination))"
                self.destinationToIntermediateStopHeightConstraint.constant = 23
            }

            if walkDistanceToDestination < 100.0 {
                self.lblWalkDistanceToDestination.alpha = 0
                self.lblWalkDistanceToDestination.text = ""
            }else{
                self.lblWalkDistanceToDestination.alpha = 1
                self.lblWalkDistanceToDestination.text = "Hasta destino: \(roadModel.formattedWalkingDistance(walkDistanceToDestination))"
            }

            self.layoutIfNeeded()
        })

    }

    func preferredHeight() -> CGFloat {
        return viewHeight
    }

}
