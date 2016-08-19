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

@IBDesignable
class MyBusMapView:MGLMapView{
    
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
     
     
     */
    
    
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
    
    
}
