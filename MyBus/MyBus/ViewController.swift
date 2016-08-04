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
import MapboxDirections
import Polyline

class ViewController: UIViewController, MGLMapViewDelegate, UITableViewDelegate
{

    @IBOutlet weak var busResultsTableView: UITableView!
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    @IBOutlet var mapView: MGLMapView!

    let minZoomLevel: Double = 9
    let maxZoomLevel: Double = 18

    let busResultCellHeight: Int = 45
    let busResultTableHeightToHide: CGFloat = 0
    let markerOriginLabelText = "Origen"
    let markerDestinationLabelText = "Destino"

    var origin: CLLocationCoordinate2D?
    var destination: CLLocationCoordinate2D?

    var bestMatches: [String] = []
    var roadResultList: [MapBusRoad] = []
    var busResultsDetail: [BusRouteResult] = []
    // MARK: - View Lifecycle Methods

    override func viewDidLoad()
    {
        super.viewDidLoad()
        setBusResultsTableViewHeight(busResultTableHeightToHide)
        initMapboxView()
    }

    func initMapboxView()
    {
        mapView.maximumZoomLevel = maxZoomLevel
        mapView.minimumZoomLevel = minZoomLevel
        mapView.userTrackingMode = .Follow
        mapView.delegate = self

        // Setup offline pack notification handlers.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.offlinePackProgressDidChange(_:)), name: MGLOfflinePackProgressChangedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.offlinePackDidReceiveError(_:)), name: MGLOfflinePackProgressChangedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.offlinePackDidReceiveMaximumAllowedMapboxTiles(_:)), name: MGLOfflinePackProgressChangedNotification, object: nil)

        // Double tapping zooms the map, so ensure that can still happen
        let doubleTap = UITapGestureRecognizer(target: self, action: nil)
        doubleTap.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(doubleTap)

        // Delay single tap recognition until it is clearly not a double
        let singleTap = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleSingleTap(_:)))
        singleTap.requireGestureRecognizerToFail(doubleTap)
        mapView.addGestureRecognizer(singleTap)
    }

    // MARK: - Tapping Methods

    func handleSingleTap(tap: UITapGestureRecognizer)
    {
        // Convert tap location (CGPoint) to geographic coordinates (CLLocationCoordinate2D)
        let tappedLocation: CLLocationCoordinate2D = mapView.convertPoint(tap.locationInView(mapView), toCoordinateFromView: mapView)

        // Remove first marker tapped from the map, add marker with coordinates
        // Prevent having more than two points selected in map

        /*
         The idea is change this behavior, if user tap a location the idea is asking him in callout what they want to do with this point (use as origin, destination, waypoint)

        if (mapView.annotations?.count != nil && mapView.annotations?.count > 1 )
        {
            mapView.removeAnnotation(mapView.annotations![0])
        }
        */

        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: tappedLocation.latitude, longitude: tappedLocation.longitude))
        {
            placemarks, error in
            if let placemark = placemarks?.first
            {
                print()
                let address = "\(placemark.thoroughfare! as String) \(placemark.subThoroughfare! as String)"

                // Declare the marker point and set its coordinates
                let mapPoint = MGLPointAnnotation()
                mapPoint.coordinate = CLLocationCoordinate2D(latitude: tappedLocation.latitude, longitude: tappedLocation.longitude)
                mapPoint.title = "Marcador"
                mapPoint.subtitle = address

                // Add marker to the map
                self.mapView.addAnnotation(mapPoint)

                // Pop-up the callout view
                self.mapView.selectAnnotation(mapPoint, animated: true)
            }
        }
    }

    // MARK: - Private Methods

    func dismissSearchController(controller: UIViewController)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Memory Management Methods

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: - MGLMapViewDelegate Methods

    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool
    {
        return true
    }

    func mapView(mapView: MGLMapView, didUpdateUserLocation userLocation: MGLUserLocation?)
    {
        mapView.centerCoordinate = (userLocation!.location?.coordinate)!
    }

    func mapViewDidFinishLoadingMap(mapView: MGLMapView)
    {
        if MGLOfflineStorage.sharedOfflineStorage().packs?.count == 0
        {
            startOfflinePackDownload()
        }
    }

    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage?
    {

        let annotationTitle = annotation.title!! as String
        let imageName = "marker"+annotation.title!! as String

        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier(annotationTitle)

        if annotationImage == nil {
            switch annotationTitle {
            case markerOriginLabelText:
                annotationImage =  self.getMarkerImage(imageName, annotationTitle: annotationTitle)
            case markerDestinationLabelText:
                annotationImage =  self.getMarkerImage(imageName, annotationTitle: annotationTitle)
            case MyBusTitle.StopOriginTitle.rawValue:
                annotationImage =  self.getMarkerImage("stopOrigen", annotationTitle: annotationTitle)
            case MyBusTitle.StopDestinationTitle.rawValue:
                annotationImage =  self.getMarkerImage("stopDestino", annotationTitle: annotationTitle)
            default:
                break
            }
        }
        return annotationImage
    }

    func mapView(mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        // Set the alpha for all shape annotations to 1 (full opacity)
        return 1
    }

    func mapView(mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        // Set the line width for polyline annotations
        return 2.0
    }

    func mapView(mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        // Give our polyline a unique color by checking for its `title` property
        let isWalkingPathPolyline = annotation.title == "Caminando" && annotation is MGLPolyline
        if isWalkingPathPolyline {
            // Mapbox cyan
            return UIColor(red: 59/255, green:178/255, blue:208/255, alpha:1)
        }
        else
        {
            return UIColor.grayColor()
        }
    }

    func mapViewRegionIsChanging(mapView: MGLMapView) {
        mapView.showsUserLocation = false
    }

    func mapView(mapView: MGLMapView, didFailToLocateUserWithError error: NSError) {
        print("error locating user: \(error.localizedDescription)")
    }

    func getMarkerImage(imageResourceIdentifier: String, annotationTitle: String) -> MGLAnnotationImage {
        var image = UIImage(named: imageResourceIdentifier)!
        image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
        return MGLAnnotationImage(image: image, reuseIdentifier: annotationTitle)
    }

    // MARK: - Mapview bus roads manipulation Methods

    func addBusRoad(mapBusRoad: MapBusRoad)
    {
        let bounds = getOriginAndDestinationInMapsBounds()

        removeExistingAnnotationsOfBusRoad()

        self.mapView.setVisibleCoordinateBounds(bounds, animated: true)

        for (index, marker) in mapBusRoad.roadStopsMarkerList.enumerate()
        {
            /**
             Resolve walking directions from user origin to first bus stop
             */

            switch index
            {
            case 0:
                // Walking path from user origin to first bus stop
                resolveAndAddWalkingPath(self.origin!, destinationCoordinate: marker.coordinate)
            case 1:
                // We check if it's a combinated road so we need three walking paths
                let isCombinatedRoad = mapBusRoad.roadStopsMarkerList.count > 2
                if isCombinatedRoad {
                    // Walking path from first bus descent stop to second bus stop
                    let nextBustStop = mapBusRoad.roadStopsMarkerList[2].coordinate
                    resolveAndAddWalkingPath(marker.coordinate, destinationCoordinate: nextBustStop)
                } else {
                    // Walking path from descent bus stop to destination
                    resolveAndAddWalkingPath(self.destination!, destinationCoordinate: marker.coordinate)
                }
            case 3:
                // Walking path from descent bus stop to destination
                resolveAndAddWalkingPath(self.destination!, destinationCoordinate: marker.coordinate)
            default:
                break
            }

            self.mapView.addAnnotation(marker)
        }

        for polyline in mapBusRoad.busRoutePolylineList
        {
            self.mapView.addAnnotation(polyline)
        }
    }

    func addBusLinesResults(results: [String], busResultsDetail: [BusRouteResult])
    {
        self.bestMatches = results
        self.busResultsDetail = busResultsDetail
        getRoadForSelectedResult(self.busResultsDetail.first)
        self.busResultsTableView.reloadData()
        self.constraintTableViewHeight.constant = CGFloat(busResultCellHeight)
        self.busResultsTableView.layoutIfNeeded()
    }

    func addOriginPosition(origin: CLLocationCoordinate2D, address: String)
    {
        if let annotations = self.mapView.annotations {
            self.mapView.removeAnnotations(annotations)
        }

        self.origin = origin
        // Declare the marker point and set its coordinates
        let originMarker = MGLPointAnnotation()
        originMarker.coordinate = origin
        originMarker.title = markerOriginLabelText
        originMarker.subtitle = address

        self.mapView.addAnnotation(originMarker)
        self.mapView.setCenterCoordinate(origin, animated: true)
    }

    func addDestinationPosition(destination: CLLocationCoordinate2D, address: String)
    {
        self.destination = destination
        // Declare the marker point and set its coordinates
        let destinationMarker = MGLPointAnnotation()
        destinationMarker.coordinate = destination
        destinationMarker.title = markerDestinationLabelText
        destinationMarker.subtitle = address

        let bounds = getOriginAndDestinationInMapsBounds()

        self.mapView.setVisibleCoordinateBounds(bounds, animated: true)

        self.mapView.addAnnotation(destinationMarker)

    }

    func addDetailedBusRoadResults(mapBusRoads: MapBusRoad, resultIndex: Int)
    {
        self.roadResultList.insert(mapBusRoads, atIndex: resultIndex)
    }

    // MARK: - Map bus road annotations utils Methods
    /**
     What are we doing in this method?

     Having origin and destination coordinate, we have to define an area (aka bounds) where user can see all markers in map

     First of all we define which position is more at south & north, and we create a padding of 800 mts for each one.
     Then we have to know if south or north is more at east to define for each one a longitude padding
     Finally we create new coordinate with padding included and build bounds with each corners
     */
    func getOriginAndDestinationInMapsBounds() -> MGLCoordinateBounds
    {
        var south, north: CLLocationCoordinate2D
        let latitudinalMeters: CLLocationDistance = 800
        let longitudinalMeters: CLLocationDistance = -800
        let southLongitudinal, northLongitudinal: CLLocationDistance

        if self.destination?.latitude < self.origin?.latitude
        {
            south = self.destination!
            north = self.origin!
        } else {
            south = self.origin!
            north = self.destination!
        }

        if south.longitude < north.longitude
        {
            southLongitudinal = -800
            northLongitudinal = 800
        } else {
            southLongitudinal = 800
            northLongitudinal = -800
        }

        // We move future Northcorner of bounds further north and more to west
        let northeastCornerPadding = MKCoordinateRegionMakeWithDistance(north, latitudinalMeters, northLongitudinal)
        // We move future Southcorner of bounds further south and more to east
        let southwestCornerPadding = MKCoordinateRegionMakeWithDistance(south, longitudinalMeters, southLongitudinal)

        let northeastCorner = CLLocationCoordinate2D(latitude: north.latitude + northeastCornerPadding.span.latitudeDelta, longitude: north.longitude + northeastCornerPadding.span.longitudeDelta)
        let southwestCorner = CLLocationCoordinate2D(latitude: south.latitude + southwestCornerPadding.span.latitudeDelta, longitude: south.longitude + southwestCornerPadding.span.longitudeDelta)

        let markerResultsBounds = MGLCoordinateBounds(sw: southwestCorner, ne: northeastCorner)
        return markerResultsBounds
    }

    func resolveAndAddWalkingPath(sourceCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) -> Void
    {
        Connectivity.sharedInstance.getWalkingDirections(sourceCoordinate, destinationCoordinate: destinationCoordinate)
        {
            response, error in
            print(error)
            if let route = response?.routes.first
            {
                let polyline = self.createWalkingPathPolyline(route)
                self.mapView.addAnnotation(polyline)
            }

        }
    }

    func createWalkingPathPolyline(route: MBRoute) -> MGLPolyline
    {
        var stepsCoordinates: [CLLocationCoordinate2D] = route.geometry
        let walkingPathPolyline = MGLPolyline(coordinates: &stepsCoordinates, count: UInt(stepsCoordinates.count))
        walkingPathPolyline.title = MyBusTitle.WalkingPathTitle.rawValue
        return walkingPathPolyline
    }


    func removeExistingAnnotationsOfBusRoad() -> Void {
        for currentMapAnnotation in self.mapView.annotations!
        {
            if isAnnotationPartOfMyBusResult(currentMapAnnotation)
            {
                self.mapView.removeAnnotation(currentMapAnnotation)
            }
        }
    }

    func isAnnotationPartOfMyBusResult(annotation: MGLAnnotation) -> Bool {
        let annotationTitle = annotation.title!! as String

        if annotationTitle == MyBusTitle.BusLineRouteTitle.rawValue ||
            annotationTitle == MyBusTitle.StopOriginTitle.rawValue ||
            annotationTitle == MyBusTitle.StopDestinationTitle.rawValue ||
            annotationTitle == MyBusTitle.WalkingPathTitle.rawValue
        {
            return true
        } else {
            return false
        }
    }

    // MARK: - UIPopoverPresentationControllerDelegate Methods

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return .None
    }

    func prepareForPopoverPresentation(popoverPresentationController: UIPopoverPresentationController)
    {
        print("prepare for presentation")
    }

    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController)
    {
        print("did dismiss")
    }

    func popoverPresentationControllerShouldDismissPopover(popoverPresentationController: UIPopoverPresentationController) -> Bool
    {
        print("should dismiss")
        return true
    }

    // MARK: - Pack Download

    func startOfflinePackDownload()
    {
        let region = MGLTilePyramidOfflineRegion(styleURL: mapView.styleURL, bounds: mapView.visibleCoordinateBounds, fromZoomLevel: minZoomLevel, toZoomLevel: maxZoomLevel)
        let userInfo = ["name": "OfflineMap"]
        let context = NSKeyedArchiver.archivedDataWithRootObject(userInfo)

        MGLOfflineStorage.sharedOfflineStorage().addPackForRegion(region, withContext: context)
        { (pack, error) in
            guard error == nil else
            {
                print("Error: \(error?.localizedFailureReason)")
                return
            }

            pack!.resume()
        }
    }

    // MARK: - MGLOfflinePack Notification Handlers

    func offlinePackProgressDidChange(notification: NSNotification)
    {
        if let pack = notification.object as? MGLOfflinePack,
            userInfo = NSKeyedUnarchiver.unarchiveObjectWithData(pack.context) as? [String: String]
        {
            let progress = pack.progress
            let completedResources = progress.countOfResourcesCompleted
            let expectedResources = progress.countOfResourcesExpected
            let progressPercentage = Float(completedResources) / Float(expectedResources)

            if completedResources == expectedResources
            {
                let byteCount = NSByteCountFormatter.stringFromByteCount(Int64(pack.progress.countOfBytesCompleted), countStyle: NSByteCountFormatterCountStyle.Memory)
                print("Offline pack “\(userInfo["name"])” completed: \(byteCount), \(completedResources) resources")
            }
            else
            {
                print("Offline pack “\(userInfo["name"])” has \(completedResources) of \(expectedResources) resources — \(progressPercentage * 100)%.")
            }
        }
    }

    func offlinePackDidReceiveError(notification: NSNotification)
    {
        if let pack = notification.object as? MGLOfflinePack,
            userInfo = NSKeyedUnarchiver.unarchiveObjectWithData(pack.context) as? [String: String],
            error = notification.userInfo?[MGLOfflinePackErrorUserInfoKey] as? NSError
        {
            print("Offline pack “\(userInfo["name"])” received error: \(error.localizedFailureReason)")
        }
    }

    func offlinePackDidReceiveMaximumAllowedMapboxTiles(notification: NSNotification)
    {
        if let pack = notification.object as? MGLOfflinePack,
            userInfo = NSKeyedUnarchiver.unarchiveObjectWithData(pack.context) as? [String: String],
            maximumCount = notification.userInfo?[MGLOfflinePackMaximumCountUserInfoKey]?.unsignedLongLongValue
        {
            print("Offline pack “\(userInfo["name"])” reached limit of \(maximumCount) tiles.")
        }
    }

    // MARK: - UITableViewDataSource Methods

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusIdentifier", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = self.bestMatches[indexPath.row]
        return cell
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return bestMatches.count
    }

    // MARK: - UITableViewDelegate Methods

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        setBusResultsTableViewHeight(CGFloat(busResultCellHeight))
        // Lisandro added the following line because if table expanded is more than 50% of view height zoom does not work as expected
        self.mapView.layoutIfNeeded()
        let route = busResultsDetail[indexPath.row]
        getRoadForSelectedResult(route)
        self.busResultsTableView.scrollToNearestSelectedRowAtScrollPosition(.Middle, animated: false)
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setBusResultsTableViewHeight(CGFloat(busResultCellHeight * self.bestMatches.count))
    }

    func setBusResultsTableViewHeight(height: CGFloat)
    {
        self.constraintTableViewHeight.constant = CGFloat(height)
        self.busResultsTableView.layoutIfNeeded()
    }

    func getRoadForSelectedResult(routeSelectedResult: BusRouteResult?) -> Void
    {
        if let route = routeSelectedResult
        {
            route.getRouteRoad(){
                road, error in
                if let routeRoad = road
                {
                    self.addBusRoad(routeRoad)
                }
            }
        }
    }
}
