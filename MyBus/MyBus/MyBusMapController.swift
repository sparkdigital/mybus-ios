//
//  ViewController.swift
//  MyBus
//
//  Created by Marcos Vivar on 4/12/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit
import Mapbox
import RealmSwift
import MapKit

class MyBusMapController: UIViewController, MGLMapViewDelegate, UITableViewDelegate {

    @IBOutlet weak var busResultsTableView: UITableView!
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    @IBOutlet var mapView: MyBusMapView!

    let busResultCellHeight: Int = 45
    let busResultTableHeightToHide: CGFloat = 0
    let progressNotification = ProgressHUD()

    var origin: RoutePoint?
    var destination: RoutePoint?

    var bestMatches: [String] = []
    var busResultsDetail: [BusRouteResult] = []

    var currentRouteDisplayed: BusRouteResult?

    var searchViewProtocol: MapBusRoadDelegate?
    
    //Temporary solution
    var userLocation:CLLocation? {
        let locationServiceAuth = CLLocationManager.authorizationStatus()
        if(locationServiceAuth == .AuthorizedAlways || locationServiceAuth == .AuthorizedWhenInUse) {
            return self.mapView.currentGPSLocation()
        } else {
            return nil
        }
    }
    
    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setBusResultsTableViewHeight(busResultTableHeightToHide)
        initMapboxView()
    }

    func initMapboxView() {
        mapView.initialize(self)

        // Setup offline pack notification handlers.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyBusMapController.offlinePackProgressDidChange(_:)), name: MGLOfflinePackProgressChangedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyBusMapController.offlinePackDidReceiveError(_:)), name: MGLOfflinePackProgressChangedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyBusMapController.offlinePackDidReceiveMaximumAllowedMapboxTiles(_:)), name: MGLOfflinePackProgressChangedNotification, object: nil)

        // Double tapping zooms the map, so ensure that can still happen
        let doubleTap = UITapGestureRecognizer(target: self, action: nil)
        doubleTap.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(doubleTap)

        // Delay single tap recognition until it is clearly not a double
        let singleLongTap = UILongPressGestureRecognizer(target: self, action: #selector(MyBusMapController.handleSingleLongTap(_:)))
        singleLongTap.requireGestureRecognizerToFail(doubleTap)
        mapView.addGestureRecognizer(singleLongTap)
    }

    // MARK: - Tapping Methods

    @IBAction func locateUserButtonTap(sender: AnyObject) {
        self.showUserLocation()
    }

    func showUserLocation() {
        let locationServiceAuth = CLLocationManager.authorizationStatus()
        if(locationServiceAuth == .AuthorizedAlways || locationServiceAuth == .AuthorizedWhenInUse) {
            self.mapView.centerMapWithGPSLocation()
        } else {
            GenerateMessageAlert.generateAlertToSetting(self)
        }
    }

    func handleSingleLongTap(tap: UITapGestureRecognizer) {
        if (tap.state == .Ended) {
            NSLog("Long press Ended")
        } else if (tap.state == .Began) {
            mapView.showsUserLocation = true
            // Convert tap location (CGPoint) to geographic coordinates (CLLocationCoordinate2D)
            let tappedLocation = mapView.convertPoint(tap.locationInView(mapView), toCoordinateFromView: mapView)

            progressNotification.showLoadingNotification(self.view)

            Connectivity.sharedInstance.getAddressFromCoordinate(tappedLocation.latitude, longitude: tappedLocation.longitude) { (routePoint, error) in
                if let destination = routePoint {
                    self.destination = destination
                    self.mapView.addDestinationPosition(destination.getLatLong(), address: destination.address)
                    self.mapView.selectDestinationMarker()
                }
                self.progressNotification.stopLoadingNotification(self.view)
            }
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
            startOfflinePackDownload()
        }
    }

    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

    /**
     This method sets the button of the annotation
     */
    func mapView(mapView: MGLMapView, rightCalloutAccessoryViewForAnnotation annotation: MGLAnnotation) -> UIView? {
        let annotationTitle = annotation.title!! as String
        // Only display button when marker is with Destino title
        if annotationTitle == MyBusTitle.DestinationTitle.rawValue {
            let button = UIButton(type: .DetailDisclosure)
            button.setImage(UIImage(named: "tabbar_route_fill"), forState: UIControlState.Normal)
            return button
        }
        return nil
    }

    /**
     This method makes the search when the button is pressed on the annotation
     */
    func mapView(mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        // Hide the callout view.
        mapView.deselectAnnotation(annotation, animated: false)
        progressNotification.showLoadingNotification(self.view)
        //Make the search
        let locationServiceAuth = CLLocationManager.authorizationStatus()
        //If origin location is diferent nil
        if (locationServiceAuth == .AuthorizedAlways || locationServiceAuth == .AuthorizedWhenInUse) {
            if let originLocation = self.mapView.currentGPSLocation()?.coordinate {
                self.mapView.addAnnotation(annotation)
                Connectivity.sharedInstance.getAddressFromCoordinate(originLocation.latitude, longitude: originLocation.longitude) { (routePoint, error) in
                    if let origin = routePoint {
                        self.origin = origin
                        SearchManager.sharedInstance.search(self.origin!, destination:self.destination!, completionHandler: {
                            (busRouteResult, error) in
                            self.progressNotification.stopLoadingNotification(self.view)
                            if let results = busRouteResult {
                                self.addBusLinesResults(results)
                            }
                        })
                    }
                }
            } else {
                self.mapView.showsUserLocation = true
                self.progressNotification.stopLoadingNotification(self.view)
            }
        } else {
            self.progressNotification.stopLoadingNotification(self.view)
            GenerateMessageAlert.generateAlertToSetting(self)
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

    // MARK: - Mapview bus roads manipulation Methods
    func addRechargePoints(rechargePoints: [RechargePoint]) -> Void {
        self.mapView.addRechargePoints(rechargePoints)
    }

    func clearRechargePoints(){
        self.mapView.clearRechargePointAnnotations()
    }

    func displayCompleteBusRoute(route: CompleteBusRoute) -> Void {
        progressNotification.showLoadingNotification(self.view)
        self.mapView.displayCompleteBusRoute(route)
        self.progressNotification.stopLoadingNotification(self.view)
        self.mapView.fitToAnnotationsInMap()
    }

    func addBusRoad(roadResult: RoadResult) {
        progressNotification.showLoadingNotification(self.view)
        self.mapView.addBusRoad(roadResult)

        // First we render polylines on Map then we remove loading notification
        self.progressNotification.stopLoadingNotification(self.view)
        self.mapView.fitToAnnotationsInMap()
    }

    func addBusLinesResults(searchResults: BusSearchResult) {
        progressNotification.showLoadingNotification(self.view)

        guard searchResults.busRouteOptions.count > 0 else {
            progressNotification.stopLoadingNotification(self.view)
            GenerateMessageAlert.generateAlert(self, title: "Malas noticias 😿", message: "Lamentablemente no pudimos resolver tu consulta. Al parecer las ubicaciones son muy cercanas ")
            return
        }
        self.mapView.addOriginPosition(searchResults.origin.getLatLong(), address: searchResults.origin.address)
        self.mapView.addDestinationPosition(searchResults.destination.getLatLong(), address: searchResults.destination.address)

        self.bestMatches = searchResults.stringifyBusRoutes()
        self.busResultsDetail = searchResults.busRouteOptions
        progressNotification.stopLoadingNotification(self.view)
        getRoadForSelectedResult(self.busResultsDetail.first)
        self.busResultsTableView.reloadData()
        self.constraintTableViewHeight.constant = CGFloat(busResultCellHeight)
        self.busResultsTableView.layoutIfNeeded()
        //Scroll to first result preventing keep previous row selected by user
        self.busResultsTableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: .Middle)
    }

    func addOriginPosition(origin: CLLocationCoordinate2D, address: String) {
        self.mapView.addOriginPosition(origin, address: address)
    }

    func addDestinationPosition(destination: CLLocationCoordinate2D, address: String) {
        self.mapView.addDestinationPosition(destination, address: address)
    }

    func clearRouteAnnotations(){
        self.mapView.clearExistingBusRouteAnnotations()
    }
    
    func resetMapSearch(){
        self.mapView.clearAllAnnotations()
        self.bestMatches = []
        self.busResultsTableView.reloadData()
        setBusResultsTableViewHeight(busResultTableHeightToHide)
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

    // MARK: - UITableViewDataSource Methods

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusIdentifier", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = self.bestMatches[indexPath.row]
        return cell
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bestMatches.count
    }

    // MARK: - UITableViewDelegate Methods

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        setBusResultsTableViewHeight(CGFloat(busResultCellHeight))
        // Lisandro added the following line because if table expanded is more than 50% of view height zoom does not work as expected
        self.mapView.layoutIfNeeded()
        let selectedRoute = busResultsDetail[indexPath.row]
        if let currentRoute = self.currentRouteDisplayed {
            if currentRoute != selectedRoute {
                progressNotification.showLoadingNotification(self.view)
                getRoadForSelectedResult(selectedRoute)
            } else {
                self.mapView.fitToAnnotationsInMap()
            }
        }
        self.busResultsTableView.scrollToNearestSelectedRowAtScrollPosition(.Middle, animated: false)
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setBusResultsTableViewHeight(CGFloat(busResultCellHeight * self.bestMatches.count))
    }

    func setBusResultsTableViewHeight(height: CGFloat) {
        self.constraintTableViewHeight.constant = CGFloat(height)
        self.busResultsTableView.layoutIfNeeded()
    }

    func getRoadForSelectedResult(routeSelectedResult: BusRouteResult?) -> Void {
        progressNotification.showLoadingNotification(self.view)
        if let route = routeSelectedResult {
            self.currentRouteDisplayed = route
            SearchManager.sharedInstance.getRoad(route) {
                road, error in
                self.progressNotification.stopLoadingNotification(self.view)
                if let routeRoad = road {
                    self.addBusRoad(routeRoad)
                } else {
                    GenerateMessageAlert.generateAlert(self, title: "Tuvimos un problema 😿", message: "No pudimos resolver el detalle de la opción seleccionada")
                }
            }
        }
    }

}
