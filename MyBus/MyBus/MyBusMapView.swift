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

    static let defaultZoomLevel:Double = 16

    //Closures

    //Closure to determine if annotation is part of road
    var annotationPartOfMyBusResultClosure: (MGLAnnotation)->Bool = { annotation in
        return (annotation is MyBusRoadResultPolyline || annotation is MyBusMarkerBusStopPoint || annotation is MyBusWalkingPolyline || annotation is MyBusMarkerIntermediateBusStopPoint)
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
    
    var annotationIsBusStop:(MGLAnnotation) -> Bool = { annotation in
        return annotation is MyBusMarkerIntermediateBusStopPoint
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
        //addAnnotations(newRoad.roadIntermediateBusStopMarkers)
        addIntermediateBusStopAnnotations(newRoad.roadIntermediateBusStopMarkers)
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
    
    func currentGPSLocation(callback:((CLLocation?, error:String?)->Void)){
        if let gpsLocation = LocationManager.sharedInstance.lastKnownLocation {
            callback(gpsLocation, error: nil)
        }else{
            LocationManager.sharedInstance.startUpdatingWithCompletionHandler({ (location, error) in
                callback(location, error: error)
            })
        }
        
    }
    
    func centerMapWithGPSLocation(zoomLevel:Double? = nil) {
        
        self.currentGPSLocation { (location, error) in
            //App just works in Mar del Plata city, so if user location is outside region, we don't center map
            let mdqRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: -37.986422, longitude: -57.608185), radius: 25000, identifier: "Mar del Plata")
            if let gpsLocation = location {
                guard mdqRegion.containsCoordinate(gpsLocation.coordinate) else {
                    return
                }
            
                self.showsUserLocation = true
                self.setCenterCoordinate(gpsLocation.coordinate, zoomLevel: (zoomLevel ?? MyBusMapView.defaultZoomLevel), animated: true)
            }else{
                NSLog("Location Error Ocurred: \(error!)")
            }
        }
        
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
            //Used 90 for top edge inset to prevent from callout view (popover) is not visible if marker is located in top edge of view
            self.showAnnotations(annotations, edgePadding: UIEdgeInsetsMake(CGFloat(90), CGFloat(30), CGFloat(30), CGFloat(30)), animated: true)
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
    
    func clearIntermediateBusStopAnnotations(){
        self.clearAnnotations(annotationIsBusStop)
    }

    
    func addIntermediateBusStopAnnotations(roadIntermediateBusStopMarkers:[MyBusMarkerIntermediateBusStopPoint]) {
        self.clearIntermediateBusStopAnnotations()
        let candidateAnnotations = self.visibleBusStops(self.zoomLevel, minZoom: self.minZoomLevel, maxZoom: self.maxZoomLevel, busStopAnnotations: roadIntermediateBusStopMarkers)
        addAnnotations(candidateAnnotations)
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
    
    private func visibleBusStops(currentZoom:Double, minZoom:Double, maxZoom:Double, busStopAnnotations:[MGLAnnotation]) -> [MGLAnnotation] {
        
        if !(busStopAnnotations.count > 0) { return []}
        
        var modN:Int = 0
        
        enum weightLevels:Double {
            case first = 1.2
            case second = 1.8
            case third = 2.8
            case fourth = 3.5
            case fifth = 4.5
        }
        
        let firstZoomLevel = minZoom + weightLevels.first.rawValue
        let secondZoomLevel = minZoom + weightLevels.second.rawValue
        let thirdZoomLevel = minZoom + weightLevels.third.rawValue
        let fourthZoomLevel = minZoom + weightLevels.fourth.rawValue
        let fifthZoomLevel = minZoom + weightLevels.fifth.rawValue
        
        switch currentZoom {
            case let x where x >= minZoom && x < firstZoomLevel:
                //Don't show annotations
                return []
            case let x where x >= firstZoomLevel && x < secondZoomLevel:
                //Show the middle annotation
                return [busStopAnnotations[busStopAnnotations.count/2]]
            case let x where x >= secondZoomLevel && x < thirdZoomLevel:
                modN = 8
                break
            case let x where x >= thirdZoomLevel && x < fourthZoomLevel:
                modN = 4
                break
            case let x where x >= fourthZoomLevel && x < fifthZoomLevel:
                modN = 2
                break
            default:
                modN = 1
        }
        
        var indexes:[Int] = [Int]()
        indexes += 0...(busStopAnnotations.count - 1)
        
        let candidates = indexes.filter { (index) -> Bool in
            return (index % modN) == 0
            }.map { (i) -> MGLAnnotation in
                return busStopAnnotations[i]
        }
        
        return candidates
        
    }


}
