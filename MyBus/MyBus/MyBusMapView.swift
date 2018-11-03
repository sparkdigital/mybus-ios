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
    @IBInspectable var walkingPathPolylineColor: UIColor = UIColor.blue

    //defaultBusPolylineColor
    @IBInspectable var defaultBusPolylineColor: UIColor = UIColor.gray

    static let defaultZoomLevel: Double = 16

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

    var annotationIsBusStop: (MGLAnnotation) -> Bool = { annotation in
        return annotation is MyBusMarkerIntermediateBusStopPoint
    }

    //Constructor
    /*
     - userTrackingMode according to MGLUserTrackingMode
     - delegate?
    */

    // Methods

    func initialize(_ delegate: MGLMapViewDelegate){
        self.maximumZoomLevel = maxZoomLevel
        self.minimumZoomLevel = minZoomLevel
        self.userTrackingMode = .none
        self.delegate = delegate


        // Add observers
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(addOriginPoint), name:NSNotification.Name(rawValue: MyBusMapModelNotificationKey.originChanged.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addDestinationPoint), name: NSNotification.Name(rawValue: MyBusMapModelNotificationKey.destinationChanged.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addRoad), name: NSNotification.Name(rawValue: MyBusMapModelNotificationKey.currentRoadChanged.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addRoute), name: NSNotification.Name(rawValue: MyBusMapModelNotificationKey.completeRouteChanged.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addRechargePointList), name: NSNotification.Name(rawValue: MyBusMapModelNotificationKey.rechargePointsChanged.rawValue), object: nil)

    }

    deinit{
        NotificationCenter.default.removeObserver(self)
    }

    func removeOriginPoint(){
        clearAnnotations(self.annotationIsOrigin)
    }

    func removeDestinationPoint(){
        clearAnnotations(self.annotationIsDestination)
    }

    fileprivate func getPropertyChangedFromNotification(_ notification:Notification) -> AnyObject {
        let userInfo:[String : AnyObject] = notification.userInfo as! [String:AnyObject]
        return userInfo[MyBusMapModel.kPropertyChangedDescriptor]!
    }

    @objc func addOriginPoint(_ notification:Notification){
        NSLog("New Origin detected")
        let newOrigin:MyBusMarkerOriginPoint = self.getPropertyChangedFromNotification(notification) as! MyBusMarkerOriginPoint

        clearRechargePointAnnotations()
        removeOriginPoint()
        addAnnotation(newOrigin)
        setCenter(newOrigin.coordinate, animated: true)
        selectMyBusAnnotation(newOrigin)
    }

    @objc func addDestinationPoint(_ notification:Notification){
        NSLog("New Destination detected")
        let newDestination:MyBusMarkerDestinationPoint = self.getPropertyChangedFromNotification(notification) as! MyBusMarkerDestinationPoint

        removeDestinationPoint()
        addAnnotation(newDestination)
        fitToAnnotationsInMap()
        selectMyBusAnnotation(newDestination)
    }

    @objc func addRoad(_ notification:Notification){
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


    @objc func addRoute(_ notification:Notification){
        NSLog("New Route detected")
        let newRoute:MyBusMapRoute = self.getPropertyChangedFromNotification(notification) as! MyBusMapRoute
        clearRechargePointAnnotations()
        self.addGoingRoute(newRoute)
    }

    func addReturnRoute(_ route: MyBusMapRoute) {
        clearAnnotations()
        addAnnotations(route.returnRouteMarkers)
        addAnnotation(route.returnRoute)
        fitToAnnotationsInMap()
    }

    func addGoingRoute(_ route: MyBusMapRoute) {
        clearAnnotations()
        addAnnotations(route.goingRouteMarkers)
        addAnnotation(route.goingRoute)
        fitToAnnotationsInMap()
    }

    @objc func addRechargePointList(_ notification:Notification){
        NSLog("New recharge list detected")
        let newRechargePoints:[MyBusMarkerRechargePoint] = self.getPropertyChangedFromNotification(notification) as! [MyBusMarkerRechargePoint]

        addAnnotations(newRechargePoints)
        fitToAnnotationsInMap()
    }

    func currentGPSLocation(_ callback:@escaping ((CLLocation?, _ error:String?)->Void)){
        if let gpsLocation = LocationManager.sharedInstance.lastKnownLocation {
            callback(gpsLocation, nil)
        }else{
            LocationManager.sharedInstance.startUpdatingWithCompletionHandler({ (location, error) in
                callback(location, error)
            })
        }

    }

    func centerMapWithGPSLocation(_ zoomLevel:Double? = nil) {

        self.currentGPSLocation { (location, error) in
            //App just works in Mar del Plata city, so if user location is outside region, we don't center map
            let mdqRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: -37.986422, longitude: -57.608185), radius: 25000, identifier: "Mar del Plata")
            if let gpsLocation = location {
                guard mdqRegion.contains(gpsLocation.coordinate) else {
                    return
                }

                self.showsUserLocation = true
                self.userLocation?.title = "Tu ubicación"
                self.setCenter(gpsLocation.coordinate, zoomLevel: (zoomLevel ?? MyBusMapView.defaultZoomLevel), animated: true)
            }else{
                NSLog("Location Error Ocurred: \(error!)")
            }
        }

    }

    func selectMyBusAnnotation(_ annotation: MyBusMarker) {
        //To prevent marker from displaying marker callout in a different position
        let seconds = 0.6
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)

        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {

            // here code perfomed with delay
            self.selectAnnotation(annotation, animated: false)

        })
    }

    // MARK: - Mapview bus roads manipulation Methods

    func fitToAnnotationsInMap() -> Void {
        if let annotations = self.annotations {
            //Used 90 for top edge inset to prevent from callout view (popover) is not visible if marker is located in top edge of view
            self.showAnnotations(annotations, edgePadding: UIEdgeInsets.init(top: CGFloat(90), left: CGFloat(30), bottom: CGFloat(30), right: CGFloat(30)), animated: true)
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


    func addIntermediateBusStopAnnotations(_ roadIntermediateBusStopMarkers:[MyBusMarkerIntermediateBusStopPoint]) {
        self.clearIntermediateBusStopAnnotations()
        let candidateAnnotations = self.visibleBusStops(self.zoomLevel, minZoom: self.minZoomLevel, busStopAnnotations: roadIntermediateBusStopMarkers)
        addAnnotations(candidateAnnotations)
    }

    fileprivate func clearAnnotations(_ criteriaClosure: ((MGLAnnotation)->Bool)? = nil){
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

    fileprivate func visibleBusStops(_ currentZoom:Double, minZoom:Double, busStopAnnotations:[MGLAnnotation]) -> [MGLAnnotation] {

        if !(busStopAnnotations.count > 0) { return []}

        var modN:Int = 0

        enum weightLevels:Double {
            case first = 1.2
            case second = 1.8
            case third = 2.8
            case fourth = 4.0 //previous: 3.5
            case fifth = 4.5
        }

        let fourthZoomLevel = minZoom + weightLevels.fourth.rawValue

        switch currentZoom {
            case let x where x >= minZoom && x < fourthZoomLevel:
                //Don't show annotations
                return []
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
