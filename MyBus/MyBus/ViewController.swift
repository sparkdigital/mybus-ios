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

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate, MGLMapViewDelegate, MapBusRoadDelegate
{

    @IBOutlet var plusButtonView: UIView!
    @IBOutlet var minusButtonView: UIView!
    @IBOutlet var compassButtonView: UIView!

    @IBOutlet var mapView : MGLMapView!
    let minZoomLevel : Double = 9
    let maxZoomLevel : Double = 18

    let markerOriginLabelText = "Origen"
    let markerDestinationLabelText = "Destino"

    var origin : CLLocationCoordinate2D?
    var destination : CLLocationCoordinate2D?

    // MARK: - View Lifecycle Methods

    override func viewDidLoad()
    {
        super.viewDidLoad()
        plusButtonView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
        plusButtonView.layer.cornerRadius = 20
        let plusButtonTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.plusButtonTap(_:)))
        plusButtonView.userInteractionEnabled = true
        plusButtonView.addGestureRecognizer(plusButtonTap)

        minusButtonView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
        minusButtonView.layer.cornerRadius = 20
        let minusButtonTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.minusButtonTap(_:)))
        minusButtonView.userInteractionEnabled = true
        minusButtonView.addGestureRecognizer(minusButtonTap)

        compassButtonView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
        compassButtonView.layer.cornerRadius = 20
        let compassButtonTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.compassButtonTap(_:)))
        compassButtonView.userInteractionEnabled = true
        compassButtonView.addGestureRecognizer(compassButtonTap)

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
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleSingleTap(_:)))
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
        if (mapView.annotations?.count != nil && mapView.annotations?.count > 1 )
        {
            mapView.removeAnnotation(mapView.annotations![0])
        }

        Connectivity.sharedInstance.getAddressFromCoordinate(tappedLocation.latitude, longitude: tappedLocation.longitude) { responseObject, error in
            let address = "\(responseObject!["calle"] as! String) \(responseObject!["altura"] as! String)"

            // Declare the marker point and set its coordinates
            let mapPoint = MGLPointAnnotation()
            mapPoint.coordinate = CLLocationCoordinate2D(latitude: tappedLocation.latitude, longitude: tappedLocation.longitude)
            mapPoint.title = address

            // Add marker to the map
            self.mapView.addAnnotation(mapPoint)

            // Pop-up the callout view
            self.mapView.selectAnnotation(mapPoint, animated: true)
        }
    }

    // MARK: - IBAction Methods

    @IBAction func searchButtonTapped(sender: AnyObject)
    {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let searchController: SearchViewController = storyboard.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController

        let sourceView = self.view

        searchController.modalPresentationStyle = .Popover
        searchController.searchViewProtocol = self

        // configure the Popover presentation controller
        let popoverController: UIPopoverPresentationController = searchController.popoverPresentationController!
        popoverController.permittedArrowDirections = .Any
        popoverController.sourceView = sourceView
        popoverController.sourceRect = sender.frame
        popoverController.delegate = self

        self.presentViewController(searchController, animated: true, completion: nil)

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

    func getMarkerImage(imageResourceIdentifier : String, annotationTitle : String) -> MGLAnnotationImage {
        var image = UIImage(named: imageResourceIdentifier)!
        image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
        return MGLAnnotationImage(image: image, reuseIdentifier: annotationTitle)
    }

    // MARK: - MapBusRoadDelegate Methods

    func newBusRoad(mapBusRoad : MapBusRoad)
    {
        for currentMapAnnotation in self.mapView.annotations! {
            let annotationTitle = currentMapAnnotation.title!! as String
            if(annotationTitle == MyBusTitle.BusLineRouteTitle.rawValue || annotationTitle == MyBusTitle.StopOriginTitle.rawValue || annotationTitle == MyBusTitle.StopDestinationTitle.rawValue) {
                self.mapView.removeAnnotation(currentMapAnnotation)
            }
        }

        for marker in mapBusRoad.markerList {
            self.mapView.addAnnotation(marker)
        }
        for polyline in mapBusRoad.polyLineList {
            self.mapView.addAnnotation(polyline)
        }

        let bounds = MGLCoordinateBounds(
            sw: (mapBusRoad.markerList.first?.coordinate)!,
            ne: (mapBusRoad.markerList.last?.coordinate)!)
        self.mapView.setZoomLevel(10, animated: true)
        self.mapView.setVisibleCoordinateBounds(bounds, animated: true)
    }

    func newOrigin(origin : CLLocationCoordinate2D)
    {
        if let annotations = self.mapView.annotations {
            self.mapView.removeAnnotations(annotations)
        }

        self.origin = origin
        // Declare the marker point and set its coordinates
        let mapPoint = MGLPointAnnotation()
        mapPoint.coordinate = origin
        mapPoint.title = markerOriginLabelText

        self.mapView.addAnnotation(mapPoint)
        self.mapView.setCenterCoordinate(origin, animated: true)
    }

    func newDestination(destination : CLLocationCoordinate2D)
    {
        self.destination = destination
        // Declare the marker point and set its coordinates
        let mapPoint = MGLPointAnnotation()
        mapPoint.coordinate = destination
        mapPoint.title = markerDestinationLabelText

        let bounds = MGLCoordinateBounds(
            sw: self.origin!,
            ne: self.destination!)
        self.mapView.setZoomLevel(10, animated: true)
        self.mapView.setVisibleCoordinateBounds(bounds, animated: true)
        self.mapView.addAnnotation(mapPoint)

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

    // MARK: - Button Handlers

    func plusButtonTap(sender: UITapGestureRecognizer)
    {
        mapView.setZoomLevel(mapView.zoomLevel+1, animated: true)
    }

    func minusButtonTap(sender: UITapGestureRecognizer)
    {
        mapView.setZoomLevel(mapView.zoomLevel-1, animated: true)
    }

    func compassButtonTap(sender: UITapGestureRecognizer)
    {
        if let userLocation = mapView.userLocation
        {
            mapView.setCenterCoordinate(userLocation.coordinate, animated: true)
        }
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

}
