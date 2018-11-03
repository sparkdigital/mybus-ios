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
@objcMembers
class MyBusMapController: UIViewController, MGLMapViewDelegate, BusesResultsMenuDelegate {

    @IBOutlet var mapView: MyBusMapView!
    @IBOutlet weak var waySwitcher: BetterSegmentedControl!

    @IBOutlet weak var roadRouteContainerHeight: NSLayoutConstraint!
    @IBOutlet var roadRouteContainerView: UIView!
    @IBOutlet weak var busesResultsCloseHandleViewContainer: UIView!
    var busesSearchOptions: BusesResultsMenuViewController!

    var isMenuExpanded: Bool {
        return (roadRouteContainerHeight.constant == roadRouteContainerHeightExpanded)
    }
    fileprivate let roadRouteContainerHeightCollapsed: CGFloat = 52.0
    fileprivate let roadRouteContainerHeightExpanded: CGFloat = 190.0

    let progressNotification = ProgressHUD()

    var destination: RoutePoint?

    var busResultsDetail: [BusRouteResult] = []
    var currentRouteDisplayed: BusRouteResult?

    var mapModel: MyBusMapModel!

    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.waySwitcher.segments = LabelSegment.segments(withTitles: ["Ida", "Vuelta"])

        self.hideBusesResultsMenu()
        self.toggleClosingHandleContainerView(false)
        self.addClosingHandleRecognizers()

        self.mapModel = MyBusMapModel()

        initMapboxView()
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(MyBusMapController.showCenterUserLocation(_:)), name: NSNotification.Name(rawValue: "applicationDidBecomeActive"), object: nil)
    }

    func initMapboxView() {
        mapView.initialize(self)


        // Setup offline pack notification handlers.
        NotificationCenter.default.addObserver(self, selector: #selector(MyBusMapController.offlinePackProgressDidChange(_:)), name: NSNotification.Name.MGLOfflinePackProgressChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MyBusMapController.offlinePackDidReceiveError(_:)), name: NSNotification.Name.MGLOfflinePackProgressChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MyBusMapController.offlinePackDidReceiveMaximumAllowedMapboxTiles(_:)), name: NSNotification.Name.MGLOfflinePackProgressChanged, object: nil)

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

    @IBAction func switchRouteVisibleWay(_ sender: BetterSegmentedControl) {
        guard let completeBusRoute = self.mapModel.completeBusRoute else {
            return
        }
        if sender.index == 0 {
            self.waySwitcher.options = [.indicatorViewBackgroundColor(UIColor.init(hexString: "0288D1"))]
            LoggingManager.sharedInstance.logEvent(LoggableAppEvent.ROUTE_GOING_TAPPED)
            self.mapView.addGoingRoute(completeBusRoute)
        } else {
            self.waySwitcher.options = [.indicatorViewBackgroundColor(UIColor.init(hexString: "EE236F"))]
            LoggingManager.sharedInstance.logEvent(LoggableAppEvent.ROUTE_RETURN_TAPPED)
            self.mapView.addReturnRoute(completeBusRoute)
        }
    }

    @IBAction func locateUserButtonTap(_ sender: AnyObject) {
        LoggingManager.sharedInstance.logEvent(LoggableAppEvent.ENDPOINT_GPS_MAP)
        self.mapView.centerMapWithGPSLocation()
    }

    func handleBusesResultMenuClose(_ recognizer:UIGestureRecognizer){
        self.collapseBusesResultsMenu()
        NotificationCenter.default.post(name: Notification.Name(rawValue: BusesResultsMenuStatusNotification.Collapsed.rawValue), object: nil)
    }

    func showCenterUserLocation(_ notification: Notification) {
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
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Mapbox delegate methods

    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        if MGLOfflineStorage.shared.packs?.count == 0 {
            //startOfflinePackDownload() Does not download offline maps programatically. //TODO User should agree
        }

        let delayTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.mapView.centerMapWithGPSLocation(12)
        }
    }

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

    func existFavoritePlace(_ address: CLLocationCoordinate2D) -> Bool {
        if let favorites = DBManager.sharedInstance.getFavourites(){
            let filter  = favorites.filter{($0.latitude) == address.latitude && ($0.longitude) == address.longitude}
            return !filter.isEmpty
        }
        return false
    }

    func getLocationByAnnotation(_ annotation: MGLAnnotation, name: String) -> RoutePoint {
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
    func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        guard (annotation is MyBusMarkerDestinationPoint || annotation is MyBusMarkerOriginPoint) else {
            return nil
        }
        let locationCoordinate = annotation.coordinate
        let alreadyIsFavorite = existFavoritePlace(locationCoordinate)
        let buttonImage = alreadyIsFavorite ? UIImage(named: "tabbar_favourite_fill") : UIImage(named: "tabbar_favourite_line")

        let button = UIButton(type: .detailDisclosure)
        button.setImage(buttonImage, for: UIControl.State())
        button.tag = alreadyIsFavorite ? 0 : 1
        return button
    }

    /**
     This method makes the search when the button is pressed on the annotation
     */
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        // Hide the callout view.
        mapView.deselectAnnotation(annotation, animated: false)
        progressNotification.showLoadingNotification(self.view)

        switch control.tag {
        case 0:
            self.progressNotification.stopLoadingNotification(self.view)
            let alert = UIAlertController(title: Localization.getLocalizedString("Eliminando"), message:  Localization.getLocalizedString("Esta_seguro"), preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: Localization.getLocalizedString("Ok"), style: UIAlertAction.Style.default) { (_) -> Void in
            let location = self.getLocationByAnnotation(annotation, name: annotation.title!!)
            DBManager.sharedInstance.removeFavorite(location)
                LoggingManager.sharedInstance.logEvent(LoggableAppEvent.FAVORITE_DEL_MARKER)
                })
            alert.addAction(UIAlertAction(title: Localization.getLocalizedString("Cancelar"), style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)

        case 1:
            self.progressNotification.stopLoadingNotification(self.view)
            let alert = UIAlertController(title: Localization.getLocalizedString("Agregando"), message: Localization.getLocalizedString("Por_Favor"), preferredStyle: UIAlertController.Style.alert)
            alert.addTextField(configurationHandler: { (textField) in textField.placeholder = "Name" })
            alert.addAction(UIAlertAction(title: Localization.getLocalizedString("Ok"), style: UIAlertAction.Style.default) { (_) -> Void in
            let location = self.getLocationByAnnotation(annotation, name: alert.textFields![0].text!)
            DBManager.sharedInstance.addFavorite(location)
                LoggingManager.sharedInstance.logEvent(LoggableAppEvent.FAVORITE_NEW_MARKER)
                })
            alert.addAction(UIAlertAction(title:  Localization.getLocalizedString("Cancelar"), style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        default: break
        }
    }

    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        if let myBusMarker = annotation as? MyBusMarker {
            return myBusMarker.markerImage
        }
        return nil
    }

    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return self.mapView.defaultAlphaForShapeAnnotation
    }

    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        return self.mapView.defaultLineWidthForPolylineAnnotation
    }

    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        if let annotation = annotation as? MyBusPolyline {
            return annotation.color ?? mapView.tintColor
        }
        return self.mapView.defaultBusPolylineColor
    }

    func mapView(_ mapView: MGLMapView, didFailToLocateUserWithError error: Error) {
        print("error locating user: \(error.localizedDescription)")
        GenerateMessageAlert.generateAlertToSetting(self)
    }

    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard let myBusMarker = annotation as? MyBusMarker else {
            return nil
        }

        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: myBusMarker.markerImageIdentifier!) {
            return annotationView
        } else {
            return myBusMarker.markerView
        }
    }

    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool){
        //NSLog("Current Zoom Level = \(mapView.zoomLevel)")
        if let myBusMapView = mapView as? MyBusMapView, let currentRoadBusStopMarkers = self.mapModel.currentRoad?.roadIntermediateBusStopMarkers {
            myBusMapView.addIntermediateBusStopAnnotations(currentRoadBusStopMarkers)
        }
    }

    // MARK: - Mapview bus roads manipulation Methods
    func addBusLinesResults(_ busRouteOptions: [BusRouteResult], preselectedRouteIndex: Int = 0){

        self.showBusesResultsMenu()

        self.busResultsDetail = busRouteOptions

        self.busesSearchOptions = BusesResultsMenuViewController()
        self.busesSearchOptions.setup(busRouteOptions)
        self.busesSearchOptions.busResultDelegate = self
        self.busesSearchOptions.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(self.busesSearchOptions)

        self.roadRouteContainerView.clearViewSubviews()

        self.view.addAutoPinnedSubview(self.busesSearchOptions!.view, toView: self.roadRouteContainerView)

        self.roadRouteContainerHeight.constant = self.roadRouteContainerHeightCollapsed

        self.busesSearchOptions.setOptionSelected(preselectedRouteIndex)


        self.loadBusLineRoad(preselectedRouteIndex)

    }

    func loadBusLineRoad(_ indexRouteSelected: Int) {
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
        let context = NSKeyedArchiver.archivedData(withRootObject: userInfo)

        MGLOfflineStorage.shared.addPack(for: region, withContext: context) { (pack, error) in
            guard error == nil else {
                print("Error: \(error?.localizedDescription ?? "")")
                return
            }

            pack!.resume()
        }
    }

    // MARK: - MGLOfflinePack Notification Handlers

    func offlinePackProgressDidChange(_ notification: Notification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String] {
            let progress = pack.progress
            let completedResources = progress.countOfResourcesCompleted
            let expectedResources = progress.countOfResourcesExpected
            let progressPercentage = Float(completedResources) / Float(expectedResources)

            if completedResources == expectedResources {
                let byteCount = ByteCountFormatter.string(fromByteCount: Int64(pack.progress.countOfBytesCompleted), countStyle: ByteCountFormatter.CountStyle.memory)
                print("Offline pack “\(userInfo["name"] ?? "")” completed: \(byteCount), \(completedResources) resources")
            } else {
                print("Offline pack “\(userInfo["name"] ?? "")” has \(completedResources) of \(expectedResources) resources — \(progressPercentage * 100)%.")
            }
        }
    }

    func offlinePackDidReceiveError(_ notification: Notification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
            let error = notification.userInfo?[MGLOfflinePackUserInfoKey.error] as? NSError {
            print("Offline pack “\(userInfo["name"] ?? "")” received error: \(error.localizedFailureReason ?? "")")
        }
    }

    func offlinePackDidReceiveMaximumAllowedMapboxTiles(_ notification: Notification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
            let maximumCount = (notification.userInfo?[MGLOfflinePackUserInfoKey.maximumCount] as AnyObject).uint64Value {
            print("Offline pack “\(userInfo["name"] ?? "")” reached limit of \(maximumCount) tiles.")
        }
    }

    func getRoadForSelectedResult(_ routeSelectedResult: BusRouteResult?) -> Void {
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
    func updateOrigin(_ newOrigin: RoutePoint?){
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

    func updateDestination(_ newDestination: RoutePoint?){
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

    func updateRoad(_ newRoad: RoadResult){
        self.clearRouteAnnotations()
        let mapRoad = MyBusMapRoad()
        mapRoad.walkingPath = MyBusPolylineFactory.buildWalkingRoutePolylineList(newRoad)
        mapRoad.roadMarkers = MyBusMarkerFactory.buildBusRoadStopMarkers(newRoad)
        mapRoad.roadIntermediateBusStopMarkers = MyBusMarkerFactory.buildIntermediateBusStopMarkers(newRoad)
        mapRoad.roadPolyline = MyBusPolylineFactory.buildBusRoutePolylineList(newRoad)
        self.mapModel.currentRoad = mapRoad
    }

    func toggleRechargePoints(_ points: [RechargePoint]?){
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

    func updateCompleteBusRoute(_ newRoute: CompleteBusRoute){
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
    func didSelectBusRouteOption(_ busRouteSelected:BusRouteResult) {
        if let currentRoute = self.currentRouteDisplayed {

            if !isMenuExpanded {
                expandBusesResultsMenu()
                NotificationCenter.default.post(name: Notification.Name(rawValue: BusesResultsMenuStatusNotification.Expanded.rawValue), object: nil)
            }else{
                if currentRoute == busRouteSelected { //double tapping
                    collapseBusesResultsMenu()
                    NotificationCenter.default.post(name: Notification.Name(rawValue: BusesResultsMenuStatusNotification.Collapsed.rawValue), object: nil)

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
        UIView.animate(withDuration: 0.3, animations: {
            self.roadRouteContainerHeight.constant = self.roadRouteContainerHeightCollapsed
            self.toggleClosingHandleContainerView(false)
            self.view.layoutIfNeeded()
        })
    }

    func expandBusesResultsMenu(){
        UIView.animate(withDuration: 0.3, animations: {
            self.roadRouteContainerHeight.constant = self.roadRouteContainerHeightExpanded
            self.toggleClosingHandleContainerView(true)
            self.view.layoutIfNeeded()
        })
    }

    func showBusesResultsMenu(){
       self.toggleBusesResultsContainerView(true)
    }

    func hideBusesResultsMenu(){
       self.toggleBusesResultsContainerView(false)
       self.toggleClosingHandleContainerView(false)
    }

    fileprivate func toggleBusesResultsContainerView(_ show:Bool){
        self.roadRouteContainerView.alpha = (show) ? CGFloat(1) : CGFloat(0)
        self.roadRouteContainerView.isUserInteractionEnabled = show
        self.roadRouteContainerHeight.constant = (show) ? self.roadRouteContainerHeightExpanded : 0
    }

    fileprivate func toggleClosingHandleContainerView(_ show:Bool){
        self.busesResultsCloseHandleViewContainer.alpha = (show) ? CGFloat(1) : CGFloat(0)
        self.busesResultsCloseHandleViewContainer.isUserInteractionEnabled = show
    }
}
