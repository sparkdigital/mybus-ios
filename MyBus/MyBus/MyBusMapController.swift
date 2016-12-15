//
//  ViewController.swift
//  MyBus
//
//  Created by Marcos Vivar on 4/12/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit
import Mapbox
import MapKit
import BetterSegmentedControl
class MyBusMapController: UIViewController, MGLMapViewDelegate, BusesResultsMenuDelegate {

    @IBOutlet var mapView: MyBusMapView!
    @IBOutlet weak var waySwitcher: BetterSegmentedControl!

    @IBOutlet weak var roadRouteContainerHeight: NSLayoutConstraint!
    @IBOutlet var roadRouteContainerView:UIView!
    @IBOutlet weak var busesResultsCloseHandleViewContainer:UIView!
    var busesSearchOptions:BusesResultsMenuViewController!
    
    var isMenuExpanded:Bool {
        return (roadRouteContainerHeight.constant == roadRouteContainerHeightExpanded)
    }
    private let roadRouteContainerHeightCollapsed:CGFloat = 52.0
    private let roadRouteContainerHeightExpanded:CGFloat = 190.0
    
    let progressNotification = ProgressHUD()

    var destination: RoutePoint?
    
    var busResultsDetail: [BusRouteResult] = []
    var currentRouteDisplayed: BusRouteResult?

    var mapModel: MyBusMapModel!
    
    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.waySwitcher.titles = ["Ida", "Vuelta"]

        self.hideBusesResultsMenu()
        self.toggleClosingHandleContainerView(false)
        self.addClosingHandleRecognizers()
        
        self.mapModel = MyBusMapModel()

        initMapboxView()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyBusMapController.showCenterUserLocation(_:)), name: "applicationDidBecomeActive", object: nil)
    }
    
    func initMapboxView() {
        mapView.initialize(self)


        // Setup offline pack notification handlers.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyBusMapController.offlinePackProgressDidChange(_:)), name: MGLOfflinePackProgressChangedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyBusMapController.offlinePackDidReceiveError(_:)), name: MGLOfflinePackProgressChangedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyBusMapController.offlinePackDidReceiveMaximumAllowedMapboxTiles(_:)), name: MGLOfflinePackProgressChangedNotification, object: nil)
        
    }
    
    
    func addClosingHandleRecognizers(){
        let tapHandleGesture = UITapGestureRecognizer(target: self, action: #selector(handleBusesResultMenuClose))
        self.busesResultsCloseHandleViewContainer.addGestureRecognizer(tapHandleGesture)
        
        let swipeHandleGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleBusesResultMenuClose))
        self.busesResultsCloseHandleViewContainer.addGestureRecognizer(swipeHandleGesture)
        
        let panHandleGesture = UIPanGestureRecognizer(target: self, action: #selector(handleBusesResultMenuClose))
        self.busesResultsCloseHandleViewContainer.addGestureRecognizer(panHandleGesture)
    }

    // MARK: - Tapping Methods

    @IBAction func switchRouteVisibleWay(sender: BetterSegmentedControl) {
        guard let completeBusRoute = self.mapModel.completeBusRoute else {
            return
        }
        if sender.index == 0 {
            self.waySwitcher.indicatorViewBackgroundColor = UIColor.init(hexString: "0288D1")
            self.mapView.addGoingRoute(completeBusRoute)
        } else {
            self.waySwitcher.indicatorViewBackgroundColor = UIColor.init(hexString: "EE236F")
            self.mapView.addReturnRoute(completeBusRoute)
        }
    }
    
    @IBAction func locateUserButtonTap(sender: AnyObject) {
        self.mapView.centerMapWithGPSLocation()
    }
    
    func handleBusesResultMenuClose(recognizer:UIGestureRecognizer){
        self.collapseBusesResultsMenu()
        NSNotificationCenter.defaultCenter().postNotificationName(BusesResultsMenuStatusNotification.Collapsed.rawValue, object: nil)
    }

    func showCenterUserLocation(notification: NSNotification) {
        //Do not center if map already has a origin marker
        guard mapModel.originMarker == nil else {
            return
        }
        if LocationManager.sharedInstance.isLocationAuthorized() {
            self.mapView.centerMapWithGPSLocation(12)
        }else{
            GenerateMessageAlert.generateAlertToSetting(self)
        }
    }

    // MARK: - Memory Management Methods

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: - Mapbox delegate methods

    func mapViewDidFinishLoadingMap(mapView: MGLMapView) {
        if MGLOfflineStorage.sharedOfflineStorage().packs?.count == 0 {
            //startOfflinePackDownload() Does not download offline maps programatically. //TODO User should agree
        }
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {            
            self.mapView.centerMapWithGPSLocation(12)
        }
    }

    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

    func existFavoritePlace(address: CLLocationCoordinate2D) -> Bool {
        if let favorites = DBManager.sharedInstance.getFavourites(){
            let filter  = favorites.filter{($0.latitude) == address.latitude && ($0.longitude) == address.longitude}
            return !filter.isEmpty
        }
        return false
    }

    func getLocationByAnnotation(annotation: MGLAnnotation, name: String) -> RoutePoint {
        let location = RoutePoint()
        location.name = name
        location.latitude = annotation.coordinate.latitude
        location.longitude = annotation.coordinate.longitude
        if let address = annotation.subtitle {
            location.address = address!
        }
        return location
    }

    /**
     This method sets the button of the annotation
     */
    func mapView(mapView: MGLMapView, leftCalloutAccessoryViewForAnnotation annotation: MGLAnnotation) -> UIView? {
        guard (annotation is MyBusMarkerDestinationPoint || annotation is MyBusMarkerOriginPoint) else {
            return nil
        }
        let locationCoordinate = annotation.coordinate
        let alreadyIsFavorite = existFavoritePlace(locationCoordinate)
        let buttonImage = alreadyIsFavorite ? UIImage(named: "tabbar_favourite_fill") : UIImage(named: "tabbar_favourite_line")

        let button = UIButton(type: .DetailDisclosure)
        button.setImage(buttonImage, forState: UIControlState.Normal)
        button.tag = alreadyIsFavorite ? 0 : 1
        return button
    }

    /**
     This method makes the search when the button is pressed on the annotation
     */
    func mapView(mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        // Hide the callout view.
        mapView.deselectAnnotation(annotation, animated: false)
        progressNotification.showLoadingNotification(self.view)

        switch control.tag {
        case 0:
            self.progressNotification.stopLoadingNotification(self.view)
            let alert = UIAlertController(title: Localization.getLocalizedString("Eliminando") , message:  Localization.getLocalizedString("Esta_seguro"), preferredStyle: UIAlertControllerStyle.ActionSheet)
            alert.addAction(UIAlertAction(title: Localization.getLocalizedString("Ok"), style: UIAlertActionStyle.Default) { (_) -> Void in
            let location = self.getLocationByAnnotation(annotation, name: annotation.title!!)
            DBManager.sharedInstance.removeFavorite(location)})
            alert.addAction(UIAlertAction(title: Localization.getLocalizedString("Cancelar"), style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        case 1:
            self.progressNotification.stopLoadingNotification(self.view)
            let alert = UIAlertController(title: Localization.getLocalizedString("Agregando"), message: Localization.getLocalizedString("Por_Favor"), preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler({ (textField) in textField.placeholder = "Name" })
            alert.addAction(UIAlertAction(title: Localization.getLocalizedString("Ok"), style: UIAlertActionStyle.Default) { (_) -> Void in
            let location = self.getLocationByAnnotation(annotation, name: alert.textFields![0].text!)
            DBManager.sharedInstance.addFavorite(location)})
            alert.addAction(UIAlertAction(title:  Localization.getLocalizedString("Cancelar"), style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        default: break
        }
    }

    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        if let myBusMarker = annotation as? MyBusMarker {
            return myBusMarker.markerImage
        }
        return nil
    }

    func mapView(mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return self.mapView.defaultAlphaForShapeAnnotation
    }

    func mapView(mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        return self.mapView.defaultLineWidthForPolylineAnnotation
    }

    func mapView(mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        if let annotation = annotation as? MyBusPolyline {
            return annotation.color ?? mapView.tintColor
        }
        return self.mapView.defaultBusPolylineColor
    }

    func mapView(mapView: MGLMapView, didFailToLocateUserWithError error: NSError) {
        print("error locating user: \(error.localizedDescription)")
        GenerateMessageAlert.generateAlertToSetting(self)
    }

    func mapView(mapView: MGLMapView, viewForAnnotation annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard let myBusMarker = annotation as? MyBusMarker else {
            return nil
        }

        if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(myBusMarker.markerImageIdentifier!) {
            return annotationView
        } else {
            return myBusMarker.markerView
        }
    }
    
    func mapView(mapView: MGLMapView, regionDidChangeAnimated animated: Bool){
        //NSLog("Current Zoom Level = \(mapView.zoomLevel)")
        if let myBusMapView = mapView as? MyBusMapView, let currentRoadBusStopMarkers = self.mapModel.currentRoad?.roadIntermediateBusStopMarkers {
            myBusMapView.addIntermediateBusStopAnnotations(currentRoadBusStopMarkers)
        }
    }
    
    // MARK: - Mapview bus roads manipulation Methods
    func addBusLinesResults(busRouteOptions: [BusRouteResult], preselectedRouteIndex: Int = 0){
        
        self.showBusesResultsMenu()

        self.busResultsDetail = busRouteOptions
        
        self.busesSearchOptions = BusesResultsMenuViewController()
        self.busesSearchOptions.setup(busRouteOptions)
        self.busesSearchOptions.busResultDelegate = self
        self.busesSearchOptions.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.busesSearchOptions)
        self.view.addAutoPinnedSubview(self.busesSearchOptions!.view, toView: self.roadRouteContainerView)
        
        self.roadRouteContainerHeight.constant = self.roadRouteContainerHeightCollapsed
        
        self.busesSearchOptions.setOptionSelected(preselectedRouteIndex)
        
        
        self.loadBusLineRoad(preselectedRouteIndex)
        
    }

    func loadBusLineRoad(indexRouteSelected: Int) {
        let bus = busResultsDetail[indexRouteSelected]
        
        getRoadForSelectedResult(bus)
        
    }


    func clearRouteAnnotations(){
        self.mapView.clearExistingBusRouteAnnotations()
        self.hideWaySwitcher()
    }

    func resetMapSearch(){
        self.mapView.clearAllAnnotations()
        self.mapModel.clearModel()
        self.hideBusesResultsMenu()
        self.hideWaySwitcher()
    }

    func hideWaySwitcher() {
        self.waySwitcher.alpha = 0
    }
    
    // MARK: - Pack Download

    func startOfflinePackDownload() {
        let region = MGLTilePyramidOfflineRegion(styleURL: mapView.styleURL, bounds: mapView.visibleCoordinateBounds, fromZoomLevel: mapView.minZoomLevel, toZoomLevel: mapView.maxZoomLevel)
        let userInfo = ["name": "OfflineMap"]
        let context = NSKeyedArchiver.archivedDataWithRootObject(userInfo)

        MGLOfflineStorage.sharedOfflineStorage().addPackForRegion(region, withContext: context) { (pack, error) in
            guard error == nil else {
                print("Error: \(error?.localizedFailureReason)")
                return
            }

            pack!.resume()
        }
    }

    // MARK: - MGLOfflinePack Notification Handlers

    func offlinePackProgressDidChange(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            userInfo = NSKeyedUnarchiver.unarchiveObjectWithData(pack.context) as? [String: String] {
            let progress = pack.progress
            let completedResources = progress.countOfResourcesCompleted
            let expectedResources = progress.countOfResourcesExpected
            let progressPercentage = Float(completedResources) / Float(expectedResources)

            if completedResources == expectedResources {
                let byteCount = NSByteCountFormatter.stringFromByteCount(Int64(pack.progress.countOfBytesCompleted), countStyle: NSByteCountFormatterCountStyle.Memory)
                print("Offline pack “\(userInfo["name"])” completed: \(byteCount), \(completedResources) resources")
            } else {
                print("Offline pack “\(userInfo["name"])” has \(completedResources) of \(expectedResources) resources — \(progressPercentage * 100)%.")
            }
        }
    }

    func offlinePackDidReceiveError(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            userInfo = NSKeyedUnarchiver.unarchiveObjectWithData(pack.context) as? [String: String],
            error = notification.userInfo?[MGLOfflinePackErrorUserInfoKey] as? NSError {
            print("Offline pack “\(userInfo["name"])” received error: \(error.localizedFailureReason)")
        }
    }

    func offlinePackDidReceiveMaximumAllowedMapboxTiles(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            userInfo = NSKeyedUnarchiver.unarchiveObjectWithData(pack.context) as? [String: String],
            maximumCount = notification.userInfo?[MGLOfflinePackMaximumCountUserInfoKey]?.unsignedLongLongValue {
            print("Offline pack “\(userInfo["name"])” reached limit of \(maximumCount) tiles.")
        }
    }
    
    func getRoadForSelectedResult(routeSelectedResult: BusRouteResult?) -> Void {
        progressNotification.showLoadingNotification(self.view)
        if let route = routeSelectedResult {
            self.currentRouteDisplayed = route
            SearchManager.sharedInstance.getRoad(route) {
                road, error in
                self.progressNotification.stopLoadingNotification(self.view)
                if let routeRoad = road {
                    self.busesSearchOptions.updateCurrentOptionWithFetchedRoad(routeRoad)
                    self.updateRoad(routeRoad)
                } else {
                    GenerateMessageAlert.generateAlert(self, title: Localization.getLocalizedString("Tuvimos_Problema"), message: Localization.getLocalizedString("NO_Pudimos"))
                }
            }
        }
    }

    //Newest implementation
    func updateOrigin(newOrigin: RoutePoint?){
        self.clearRouteAnnotations()
        self.mapView.clearExistingBusRoadAnnotations()
        hideBusesResultsMenu()
        if let origin = newOrigin {
            let marker = MyBusMarkerFactory.createOriginPointMarker(origin)
            self.mapModel.originMarker = marker
            self.mapModel.currentRoad = nil
        }else{
            self.mapView.removeOriginPoint()
            self.mapModel.originMarker = nil
        }

        //If destination is set, we should fit to origin and destionation marker
        if let _ = self.mapModel.destinationMarker {
            self.mapView.fitToAnnotationsInMap()
        }
    }

    func updateDestination(newDestination: RoutePoint?){
        self.clearRouteAnnotations()
        self.mapView.clearExistingBusRoadAnnotations()
        hideBusesResultsMenu()
        if let destination = newDestination {
            let marker = MyBusMarkerFactory.createDestinationPointMarker(destination)
            self.mapModel.destinationMarker = marker
            self.mapModel.currentRoad = nil
        }else{
            self.mapView.removeDestinationPoint()
            self.mapModel.destinationMarker = nil
        }
    }

    func updateRoad(newRoad: RoadResult){
        self.clearRouteAnnotations()
        let mapRoad = MyBusMapRoad()
        mapRoad.walkingPath = MyBusPolylineFactory.buildWalkingRoutePolylineList(newRoad)
        mapRoad.roadMarkers = MyBusMarkerFactory.buildBusRoadStopMarkers(newRoad)
        mapRoad.roadIntermediateBusStopMarkers = MyBusMarkerFactory.buildIntermediateBusStopMarkers(newRoad)
        mapRoad.roadPolyline = MyBusPolylineFactory.buildBusRoutePolylineList(newRoad)
        self.mapModel.currentRoad = mapRoad
    }

    func toggleRechargePoints(points: [RechargePoint]?){
        if let points = points {
            let rechargePointAnnotations = points.map { (point: RechargePoint) -> MyBusMarkerRechargePoint in
                return MyBusMarkerFactory.createRechargePointMarker(point)
            }
            self.mapModel.rechargePointList = rechargePointAnnotations
        }else{
            //Should clear the annotations in the model???
            self.mapView.clearRechargePointAnnotations()
        }
    }

    func updateCompleteBusRoute(newRoute: CompleteBusRoute){
        self.mapModel.originMarker = nil
        self.mapModel.destinationMarker = nil
        self.mapModel.currentRoad = nil
        self.mapView.clearAllAnnotations()

        let mapRoute = MyBusMapRoute()
        
        mapRoute.markers = MyBusMarkerFactory.buildCompleteBusRoadStopMarkers(newRoute)
        mapRoute.polyline = MyBusPolylineFactory.buildCompleteBusRoutePolylineList(newRoute)
        
        mapRoute.goingRouteMarkers = MyBusMarkerFactory.buildGoingBusRouteStopMarkers(newRoute)
        mapRoute.goingRoute = mapRoute.polyline.first
        
        mapRoute.returnRouteMarkers = MyBusMarkerFactory.buildReturnBusRouteStopMarkers(newRoute)
        mapRoute.returnRoute = mapRoute.polyline.last
        
        self.mapModel.completeBusRoute = mapRoute
        
        self.waySwitcher.alpha = 1
        do {
            try self.waySwitcher.setIndex(0)
        } catch {
            NSLog("Error initializing complete bus route switcher at index O")
        }
    }
    
    // MARK: BusesResultsMenuViewController protocol delegate methods and additional functions
    func didSelectBusRouteOption(busRouteSelected:BusRouteResult) {
        if let currentRoute = self.currentRouteDisplayed {
            
            if !isMenuExpanded {
                expandBusesResultsMenu()
                NSNotificationCenter.defaultCenter().postNotificationName(BusesResultsMenuStatusNotification.Expanded.rawValue, object: nil)
            }else{
                if currentRoute == busRouteSelected { //double tapping
                    collapseBusesResultsMenu()
                    NSNotificationCenter.defaultCenter().postNotificationName(BusesResultsMenuStatusNotification.Collapsed.rawValue, object: nil)

                }
            }
            
            if currentRoute != busRouteSelected {
                progressNotification.showLoadingNotification(self.view)
                getRoadForSelectedResult(busRouteSelected)
            } else {
                self.mapView.fitToAnnotationsInMap()
            }
            
            
        }
    }
    
    func collapseBusesResultsMenu(){
        UIView.animateWithDuration(0.3) {
            self.roadRouteContainerHeight.constant = self.roadRouteContainerHeightCollapsed
            self.toggleClosingHandleContainerView(false)
            self.view.layoutIfNeeded()
        }
    }
    
    func expandBusesResultsMenu(){
        UIView.animateWithDuration(0.3) {
            self.roadRouteContainerHeight.constant = self.roadRouteContainerHeightExpanded
            self.toggleClosingHandleContainerView(true)
            self.view.layoutIfNeeded()
        }
    }
    
    func showBusesResultsMenu(){
       self.toggleBusesResultsContainerView(true)
    }
    
    func hideBusesResultsMenu(){
       self.toggleBusesResultsContainerView(false)
       self.toggleClosingHandleContainerView(false)
    }
    
    private func toggleBusesResultsContainerView(show:Bool){
        self.roadRouteContainerView.alpha = (show) ? CGFloat(1) : CGFloat(0)
        self.roadRouteContainerView.userInteractionEnabled = show
        self.roadRouteContainerHeight.constant = (show) ? self.roadRouteContainerHeightExpanded : 0
    }
    
    private func toggleClosingHandleContainerView(show:Bool){
        self.busesResultsCloseHandleViewContainer.alpha = (show) ? CGFloat(1) : CGFloat(0)
        self.busesResultsCloseHandleViewContainer.userInteractionEnabled = show
    }
}