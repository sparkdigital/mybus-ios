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
    
    var annotationIsOrigin: (MGLAnnotation) -> Bool = { annotation in
        return annotation is MyBusMarkerOriginPoint
    }
    
    var annotationIsDestination: (MGLAnnotation) -> Bool = { annotation in
        return annotation is MyBusMarkerDestinationPoint
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
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func removeOriginPoint(){
        clearAnnotations(self.annotationIsOrigin)
    }
    
    func removeDestinationPoint(){
        clearAnnotations(self.annotationIsDestination)
    }

    private func getPropertyChangedFromNotification(notification:NSNotification) -> AnyObject {
        let userInfo:[String : AnyObject] = notification.userInfo as! [String:AnyObject]
        return userInfo[MyBusMapModel.kPropertyChangedDescriptor]!
    }
    
    func addOriginPoint(notification:NSNotification){
        NSLog("New Origin detected")
        let newOrigin:MyBusMarkerOriginPoint = self.getPropertyChangedFromNotification(notification) as! MyBusMarkerOriginPoint
        
        removeOriginPoint()
        addAnnotation(newOrigin)
        setCenterCoordinate(newOrigin.coordinate, animated: true)
        selectMyBusAnnotation(newOrigin)
    }
    
    func addDestinationPoint(notification:NSNotification){
        NSLog("New Destination detected")
        let newDestination:MyBusMarkerDestinationPoint = self.getPropertyChangedFromNotification(notification) as! MyBusMarkerDestinationPoint
        
        removeDestinationPoint()
        addAnnotation(newDestination)
        fitToAnnotationsInMap()
        selectMyBusAnnotation(newDestination)
    }
    
    func addRoad(notification:NSNotification){
        NSLog("New Road detected")
        let newRoad:MyBusMapRoad = self.getPropertyChangedFromNotification(notification) as! MyBusMapRoad
        
        clearExistingBusRoadAnnotations()
        addAnnotations(newRoad.walkingPath)
        addAnnotations(newRoad.roadMarkers)
        addAnnotations(newRoad.roadPolyline)
        fitToAnnotationsInMap()
    }
    

    func addRoute(notification:NSNotification){
        NSLog("New Route detected")
        let newRoute:MyBusMapRoute = self.getPropertyChangedFromNotification(notification) as! MyBusMapRoute
        
        clearAnnotations()
        addAnnotations(newRoute.markers)
        addAnnotations(newRoute.polyline)
        fitToAnnotationsInMap()
    }
    
    func addRechargePointList(notification:NSNotification){
        NSLog("New recharge list detected")
        let newRechargePoints:[MyBusMarkerRechargePoint] = self.getPropertyChangedFromNotification(notification) as! [MyBusMarkerRechargePoint]
        
        addAnnotations(newRechargePoints)
        fitToAnnotationsInMap()
    }

    func currentGPSLocation()->CLLocation?{
        return self.userLocation?.location
    }
    
    func centerMapWithGPSLocation() -> Void {
        self.showsUserLocation = true
        self.centerCoordinate = (self.currentGPSLocation()?.coordinate)!
        self.setZoomLevel(16, animated: false)
    }
    
    func centerMapWithGPSLocationWithZoom(zoom : Double) -> Void {
        self.showsUserLocation = true
        self.centerCoordinate = (self.currentGPSLocation()?.coordinate)!
        self.setZoomLevel(zoom, animated: false)
    }

    func selectMyBusAnnotation(annotation: MyBusMarker) {
        //To prevent marker from displaying marker callout in a different position
        let seconds = 0.6
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            // here code perfomed with delay
            self.selectAnnotation(annotation, animated: false)
            
        })
    }
    
    // MARK: - Mapview bus roads manipulation Methods
    
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
