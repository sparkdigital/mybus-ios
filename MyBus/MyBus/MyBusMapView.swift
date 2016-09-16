//
//  MyBusMapView.swift
//  MyBus
//
//  Created by Sebastian Fink on 8/18/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import UIKit
import Mapbox
import MapKit
import MapboxDirections

//Annotations


class MyBusAnnotationFactory {
    
    class func createOriginPointMarker(){
    }
    
    class func createDestinationPointMarker(){
    }
    
}




@IBDesignable
class MyBusMapView:MGLMapView{
   
    
    // This needs to be refactored
    var origin:CLLocationCoordinate2D!
    var destination:CLLocationCoordinate2D!
    let markerOriginLabelText = "Origen"
    let markerDestinationLabelText = "Destino"

    
    
    //Attributes
    @IBInspectable var maxZoomLevel: Double = 18.0 {
        didSet{
            self.maximumZoomLevel = maxZoomLevel
        }
    }
    
    @IBInspectable var minZoomLevel:Double = 9.0 {
        didSet {
            self.minimumZoomLevel = minZoomLevel
        }
    }
    
    //alphaForAnnotation
    @IBInspectable var defaultAlphaForShapeAnnotation:CGFloat = 1.0
    
    //lineWidthForPolilyneAnnotation
    @IBInspectable var defaultLineWidthForPolylineAnnotation:CGFloat = 2.0
    
    
    //walkingPathPolylineColor
    @IBInspectable var walkingPathPolylineColor:UIColor = UIColor.blueColor()
    
    //defaultBusPolylineColor
    @IBInspectable var defaultBusPolylineColor:UIColor = UIColor.grayColor()
    
    
    //Closures
    
    //Closure to determine if annotation is part of road
    var annotationPartOfMyBusResultClosure:(MGLAnnotation)->Bool = { annotation in
        
        guard let annotationTitle:String = annotation.title!! as String else {
            NSLog("No title found in annotation when filtering")
            return false
        }
        
        switch annotationTitle{
            case MyBusTitle.BusLineRouteTitle.rawValue:
                return true
            case MyBusTitle.StopOriginTitle.rawValue:
                return true
            case  MyBusTitle.StopDestinationTitle.rawValue:
                return true
            case MyBusTitle.WalkingPathTitle.rawValue:
                return true
            default:
                return false
        }
    }
    
    //Closure to determine if annotation is part of route
    var annotationPartOfCompleteRouteClosure:(MGLAnnotation)->Bool = { annotation in
        
        guard let annotationTitle:String = annotation.title!! as String else {
            NSLog("No title found in annotation when filtering")
            return false
        }
        
        switch annotationTitle{
        case MyBusTitle.StartCompleteBusRoute.rawValue:
            return true
        case MyBusTitle.SameStartEndCompleteBusRoute.rawValue:
            return true
        case MyBusTitle.EndCompleteBusRoute.rawValue:
            return true
        case "Going":
            return true
        case "Return":
            return true
        default:
            return false
        }
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
    
    
    
    
    
    
    
    //markerOrigen
    //markerDestino
    //stopOrigen
    //stopDestino
    
    
    //Constructor
    /*
     - userTrackingMode according to MGLUserTrackingMode
     - delegate?
     */
    
    
    /*
     
     ANNOTATIONS
     MARKERS
     POLYLINES
     
     */
    
    
    
    // Methods
    
    /*
     
     -addPoint(title, subtitle, CLLocationCoordinate2D) -> MGLPointAnnotation
     -selectPoint(annotation)
     -getMarkerImage( title? o enumType?) -> UIImage
     
     
     - addPolylineAnnotationForRoute(mbroute)
     
     
     - centerMapWithGPSLocation
     - addPoint
     - addRoad
     - addRoute
     
     
     
     */
    
    
    func getMarkerImage(imageResourceIdentifier: String, annotationTitle: String) -> MGLAnnotationImage {
        var image = UIImage(named: imageResourceIdentifier)!
        image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
        return MGLAnnotationImage(image: image, reuseIdentifier: annotationTitle)
    }

    
    // MARK: - Mapview bus roads manipulation Methods
    
    func displayCompleteBusRoute(route: CompleteBusRoute) -> Void {
        //progressNotification.showLoadingNotification(self.view)
        
        /*removeExistingAnnotationsOfBusRoad()
        removeExistingAnnotationsOfCompleteRoute()
        */
        clearExistingBusRoadAnnotations()
        clearExistingBusRouteAnnotations()
        
        let bounds = getOriginAndDestinationInMapsBounds((route.goingPointList.first?.getLatLong())!, secondPoint: (route.returnPointList.first?.getLatLong())!)
        
        self.setVisibleCoordinateBounds(bounds, animated: true)
        //self.mapView.setVisibleCoordinateBounds(bounds, animated: true)
        for marker in route.getMarkersAnnotation() {
            //self.mapView.addAnnotation(marker)
            self.addAnnotation(marker)
        }
        
        for polyline in route.getPolyLines() {
            //self.mapView.addAnnotation(polyline)
            self.addAnnotation(polyline)
        }
        //self.progressNotification.stopLoadingNotification(self.view)
    }

    
    
    func addBusRoad(roadResult: RoadResult) {
        //progressNotification.showLoadingNotification(self.view)
        let mapBusRoad = MapBusRoad().addBusRoadOnMap(roadResult)
        let walkingRoutes = roadResult.walkingRoutes
        
        let bounds = getOriginAndDestinationInMapsBounds(self.destination!, secondPoint: self.origin!)
        
        //removeExistingAnnotationsOfBusRoad()
        clearExistingBusRoadAnnotations()
        
        self.setVisibleCoordinateBounds(bounds, animated: true)
        
        for walkingRoute in walkingRoutes {
            let walkingPolyline = self.createWalkingPathPolyline(walkingRoute)
            //self.mapView.addAnnotation(walkingPolyline)
            self.addAnnotation(walkingPolyline)
        }
        
        for marker in mapBusRoad.roadStopsMarkerList {
            //self.mapView.addAnnotation(marker)
            self.addAnnotation(marker)
        }
        
        for polyline in mapBusRoad.busRoutePolylineList {
            //self.mapView.addAnnotation(polyline)
            self.addAnnotation(polyline)
        }
        // First we render polylines on Map then we remove loading notification
        //self.progressNotification.stopLoadingNotification(self.view)
    }


    
    
    
    
    func addOriginPosition(origin: CLLocationCoordinate2D, address: String) {
        /*if let annotations = self.mapView.annotations {
            self.mapView.removeAnnotations(annotations)
        }*/
        if let annotations = self.annotations {
            self.removeAnnotations(annotations)
        }
        
        self.origin = origin
        // Declare the marker point and set its coordinates
        let originMarker = MGLPointAnnotation()
        originMarker.coordinate = origin
        originMarker.title = markerOriginLabelText
        originMarker.subtitle = address
        
        //self.mapView.addAnnotation(originMarker)
        //self.mapView.setCenterCoordinate(origin, animated: true)
        self.addAnnotation(originMarker)
        self.setCenterCoordinate(origin, animated: true)
    }
    
    func addDestinationPosition(destination: CLLocationCoordinate2D, address: String) {
        self.destination = destination
        // Declare the marker point and set its coordinates
        let destinationMarker = MGLPointAnnotation()
        destinationMarker.coordinate = destination
        destinationMarker.title = markerDestinationLabelText
        destinationMarker.subtitle = address
        
        let bounds = getOriginAndDestinationInMapsBounds(self.destination!, secondPoint: self.origin!)
        
        //self.mapView.setVisibleCoordinateBounds(bounds, animated: true)
        self.setVisibleCoordinateBounds(bounds, animated:true)
        
        //self.mapView.addAnnotation(destinationMarker)
        self.addAnnotation(destinationMarker)
        
    }

    
    
    // MARK: - Map bus road annotations utils Methods
    /**
     What are we doing in this method?
     
     Having origin and destination coordinate, we have to define an area (aka bounds) where user can see all markers in map
     
     First of all we define which position is more at south & north, and we create a padding of 800 mts for each one.
     Then we have to know if south or north is more at east to define for each one a longitude padding
     Finally we create new coordinate with padding included and build bounds with each corners
     */
    func getOriginAndDestinationInMapsBounds(firstPoint: CLLocationCoordinate2D, secondPoint: CLLocationCoordinate2D) -> MGLCoordinateBounds {
        var south, north: CLLocationCoordinate2D
        let latitudinalMeters: CLLocationDistance = 800
        let longitudinalMeters: CLLocationDistance = -800
        let southLongitudinal, northLongitudinal: CLLocationDistance
        
        if firstPoint.latitude < secondPoint.latitude {
            south = firstPoint
            north = secondPoint
        } else {
            south = secondPoint
            north = firstPoint
        }
        
        if south.longitude < north.longitude {
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
    
    
    
    func createWalkingPathPolyline(route: MBRoute) -> MGLPolyline {
        var stepsCoordinates: [CLLocationCoordinate2D] = route.geometry
        let walkingPathPolyline = MGLPolyline(coordinates: &stepsCoordinates, count: UInt(stepsCoordinates.count))
        walkingPathPolyline.title = MyBusTitle.WalkingPathTitle.rawValue
        return walkingPathPolyline
    }
    
    func clearExistingBusRoadAnnotations(){
        self.clearAnnotations(annotationPartOfMyBusResultClosure)
    }
    
    func clearExistingBusRouteAnnotations(){
        self.clearAnnotations(annotationPartOfCompleteRouteClosure)
    }
    
    private func clearAnnotations(criteriaClosure:((MGLAnnotation)->Bool)){
        guard let annotations = self.annotations else {
            NSLog("No Road annotations were found")
            return
        }
        
        //Determine the annotations to be removed
        let annotationsToRemove = annotations.filter(criteriaClosure)
        
        for current in annotationsToRemove{
            self.removeAnnotation(current)
        }
    }
    
    
    /*
    func removeExistingAnnotationsOfBusRoad() -> Void {
        //if let annotations = self.mapView.annotations {
        if let annotations = self.annotations {
            for currentMapAnnotation in annotations {
                if self.isAnnotationPartOfMyBusResult(currentMapAnnotation) {
                    //self.mapView.removeAnnotation(currentMapAnnotation)
                    self.removeAnnotation(currentMapAnnotation)
                }
            }
        }
    }*/
    
    /*
    func removeExistingAnnotationsOfCompleteRoute() -> Void {
        //if let annotations = self.mapView.annotations {
        if let annotations = self.annotations {
            for currentMapAnnotation in annotations {
                if self.isAnnotationPartOfCompleteRoute(currentMapAnnotation) {
                    //self.mapView.removeAnnotation(currentMapAnnotation)
                    self.removeAnnotation(currentMapAnnotation)
                }
            }
        }
    }*/

    
    /*
    func isAnnotationPartOfMyBusResult(annotation: MGLAnnotation) -> Bool {
        let annotationTitle = annotation.title!! as String
        
        if annotationTitle == MyBusTitle.BusLineRouteTitle.rawValue ||
            annotationTitle == MyBusTitle.StopOriginTitle.rawValue ||
            annotationTitle == MyBusTitle.StopDestinationTitle.rawValue ||
            annotationTitle == MyBusTitle.WalkingPathTitle.rawValue {
            return true
        } else {
            return false
        }
    }*/
    
    
    /*
    func isAnnotationPartOfCompleteRoute(annotation: MGLAnnotation) -> Bool {
        let annotationTitle = annotation.title!! as String
        
        if ~/MyBusTitle.StartCompleteBusRoute.rawValue ~= annotationTitle  ||
            ~/MyBusTitle.SameStartEndCompleteBusRoute.rawValue ~= annotationTitle ||
            ~/MyBusTitle.EndCompleteBusRoute.rawValue ~= annotationTitle ||
            annotationTitle == "Going" ||
            annotationTitle == "Return" {
            return true
        } else {
            return false
        }
    }*/
    
    
}
