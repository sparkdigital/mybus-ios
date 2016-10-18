//
//  MyBusMapView.swift
//  MyBus
//
//  Created by Sebastian Fink on 8/18/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import Mapbox

@IBDesignable
class MyBusMapView: MGLMapView{


    // This needs to be refactored
    var origin: CLLocationCoordinate2D!
    var destination: CLLocationCoordinate2D!

    //Attributes
    @IBInspectable var maxZoomLevel: Double = 18.0 {
        didSet{
            self.maximumZoomLevel = maxZoomLevel
        }
    }

    @IBInspectable var minZoomLevel: Double = 9.0 {
        didSet {
            self.minimumZoomLevel = minZoomLevel
        }
    }

    //alphaForAnnotation
    @IBInspectable var defaultAlphaForShapeAnnotation: CGFloat = 1.0

    //lineWidthForPolilyneAnnotation
    @IBInspectable var defaultLineWidthForPolylineAnnotation: CGFloat = 2.0


    //walkingPathPolylineColor
    @IBInspectable var walkingPathPolylineColor: UIColor = UIColor.blueColor()

    //defaultBusPolylineColor
    @IBInspectable var defaultBusPolylineColor: UIColor = UIColor.grayColor()


    //Closures

    //Closure to determine if annotation is part of road
    var annotationPartOfMyBusResultClosure: (MGLAnnotation)->Bool = { annotation in
        return (annotation is MyBusRoadResultPolyline || annotation is MyBusMarkerBusStopPoint || annotation is MyBusWalkingPolyline)
    }

    //Closure to determine if annotation is part of route
    var annotationPartOfCompleteRouteClosure: (MGLAnnotation)->Bool = { annotation in
        return (annotation is MyBusMarkerCompleteRoutePoint || annotation is MyBusGoingCompleteBusRoutePolyline || annotation is MyBusReturnCompleteBusRoutePolyline)
    }

    var annotationIsRechargePointClosure: (MGLAnnotation)->Bool = { annotation in
        return (annotation is MyBusMarkerRechargePoint)
    }

    var annotationIsOriginOrDestination: (MGLAnnotation) -> Bool = {
        annotation in        
        return annotation is MyBusMarkerOriginPoint || annotation is MyBusMarkerDestinationPoint
    }

    //Constructor
    /*
     - userTrackingMode according to MGLUserTrackingMode
     - delegate?
    */

    // Methods

    func initialize(delegate: MGLMapViewDelegate){
        self.maximumZoomLevel = maxZoomLevel
        self.minimumZoomLevel = minZoomLevel
        self.userTrackingMode = .None
        self.delegate = delegate
        
        
        // Add observers
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(addOriginPoint), name:MyBusMapModelNotificationKey.originChanged.rawValue , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(addDestinationPoint), name: MyBusMapModelNotificationKey.destinationChanged.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(addRoad), name: MyBusMapModelNotificationKey.currentRoadChanged.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(addRoute), name: MyBusMapModelNotificationKey.completeRouteChanged.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(addRechargePointList), name: MyBusMapModelNotificationKey.rechargePointsChanged.rawValue, object: nil)
        
    }


    func addOriginPoint(notification:NSNotification){
    }
    func addDestinationPoint(notification:NSNotification){
    }
    
    func addRoad(notification:NSNotification){
        
    }
    func addRoute(notification:NSNotification){
        
    }
    func addRechargePointList(notification:NSNotification){
        
    }

    func currentGPSLocation()->CLLocation?{
        return self.userLocation?.location
    }
    
    func centerMapWithGPSLocation() -> Void {
        self.showsUserLocation = true
        self.centerCoordinate = (self.currentGPSLocation()?.coordinate)!
        self.setZoomLevel(16, animated: false)
    }

    func addRechargePoints(rechargePoints: [RechargePoint]) -> Void {

        let rechargePointAnnotations = rechargePoints.map { (point: RechargePoint) -> MyBusMarkerRechargePoint in
            return MyBusMarkerFactory.createRechargePointMarker(point)
        }
        self.addAnnotations(rechargePointAnnotations)
        self.fitToAnnotationsInMap()

    }

    func selectDestinationMarker() -> Void {
        if let annotations = self.annotations {
            for annotation in annotations {
                if annotation.title! == MyBusTitle.DestinationTitle.rawValue {
                    self.setCenterCoordinate(annotation.coordinate, zoomLevel: 14, animated: false)
                    self.selectAnnotation(annotation, animated: false)
                }
            }
        }
    }

    // MARK: - Mapview bus roads manipulation Methods

    func displayCompleteBusRoute(route: CompleteBusRoute) -> Void {
        clearAnnotations()

        let roadStopsMarkerList = MyBusMarkerFactory.buildCompleteBusRoadStopMarkers(route)
        self.addAnnotations(roadStopsMarkerList)

        let busRoutePolylineList = MyBusPolylineFactory.buildCompleteBusRoutePolylineList(route)
        self.addAnnotations(busRoutePolylineList)
    }


    func addBusRoad(roadResult: RoadResult) {
        clearExistingBusRoadAnnotations()

        let walkingPolylineList = MyBusPolylineFactory.buildWalkingRoutePolylineList(roadResult)
        self.addAnnotations(walkingPolylineList)

        let roadStopsMarkerList = MyBusMarkerFactory.buildBusRoadStopMarkers(roadResult)
        self.addAnnotations(roadStopsMarkerList)

        let busRoutePolylineList = MyBusPolylineFactory.buildBusRoutePolylineList(roadResult)
        self.addAnnotations(busRoutePolylineList)

    }

    func addOriginPosition(origin: CLLocationCoordinate2D, address: String) {
        self.clearAllAnnotations()

        self.origin = origin
        let originMarker = MyBusMarkerFactory.createOriginPointMarker(origin, address: address)
        self.addAnnotation(originMarker)

        self.setCenterCoordinate(origin, animated: true)
    }

    func addDestinationPosition(destination: CLLocationCoordinate2D, address: String) {
        self.destination = destination

        // Declare the marker point and set its coordinates
        let destinationMarker = MyBusMarkerFactory.createDestinationPointMarker(destination, address: address)

        self.addAnnotation(destinationMarker)
        self.fitToAnnotationsInMap()

    }

    func fitToAnnotationsInMap() -> Void {
        if let annotations = self.annotations {
            self.showAnnotations(annotations, edgePadding: UIEdgeInsetsMake(CGFloat(30), CGFloat(30), CGFloat(30), CGFloat(30)), animated: true)
        }
    }

    func clearAllAnnotations(){
        self.clearAnnotations() //don't use a criteria
    }

    func clearExistingBusRoadAnnotations(){
        self.clearAnnotations(annotationPartOfMyBusResultClosure)
    }

    func clearExistingBusRouteAnnotations(){
        self.clearAnnotations(annotationPartOfCompleteRouteClosure)
    }

    func clearExistingOriginAndDestinationAnnotations(){
        self.clearAnnotations(annotationIsOriginOrDestination)
    }

    func clearRechargePointAnnotations(){
        self.clearAnnotations(annotationIsRechargePointClosure)
    }

    private func clearAnnotations(criteriaClosure: ((MGLAnnotation)->Bool)? = nil){
        guard let annotations = self.annotations else {
            NSLog("No Road annotations were found")
            return
        }

        //Determine the annotations to be removed
        if let criteria = criteriaClosure {
            let annotationsToRemove = annotations.filter(criteria)
            for current in annotationsToRemove{
                self.removeAnnotation(current)
            }
        }else{
            self.removeAnnotations(annotations)
        }

    }

}
