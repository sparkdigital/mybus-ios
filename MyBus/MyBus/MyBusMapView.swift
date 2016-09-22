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
class MyBusMarkerAddressPoint:MyBusMarker {}
class MyBusMarkerBusStopPoint:MyBusMarker{}
class MyBusMarkerRechargePoint:MyBusMarker{}

class MyBusMarker: MGLPointAnnotation {
    var markerImageIdentifier:String?
    var markerImage:MGLAnnotationImage? {
        get {
            guard let identifier = markerImageIdentifier else { return nil }
            if var image = UIImage(named: identifier) {
                image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
                return MGLAnnotationImage(image: image, reuseIdentifier: identifier)
            }
            return nil
        }
    }
    
    // MARK: MyBusMarker Constructor
    init(position:CLLocationCoordinate2D, title:String, subtitle:String? = "", imageIdentifier:String?) {
        super.init()
        self.coordinate = position
        self.title = title
        self.subtitle = subtitle
        self.markerImageIdentifier = imageIdentifier
    }
   
}

// MARK: Markers factory methods
class MyBusMarkerFactory {
    
    class func buildBusRoadStopMarkers(roadResult:RoadResult)->[MGLAnnotation]{
        
        var roadStopsMarkerList:[MGLAnnotation] = []
        
        let busRouteType: MyBusRouteResultType = roadResult.busRouteResultType()
        
        if let firstRoute = roadResult.routeList.first, let lastRoute = roadResult.routeList.last {
            switch busRouteType {
            case .Single:
                
                let stopOriginMapPoint = MyBusMarkerFactory.createBusStopOriginMarker(firstRoute.getFirstLatLng(), address: MyBusTitle.StopOriginTitle.rawValue)
                roadStopsMarkerList.append(stopOriginMapPoint)
                
                let stopDestinationMapPoint = MyBusMarkerFactory.createBusStopDestinationMarker(firstRoute.getLastLatLng(), address: MyBusTitle.StopDestinationTitle.rawValue)
                roadStopsMarkerList.append(stopDestinationMapPoint)
            
            case .Combined:
                //First bus
                // StopOriginRouteOne
                let mapStopOriginRouteOne = MyBusMarkerFactory.createBusStopOriginMarker(firstRoute.getFirstLatLng(), address: MyBusTitle.StopOriginTitle.rawValue)
                roadStopsMarkerList.append(mapStopOriginRouteOne)
                
                // StopDestinationRouteOne
                let mapStopDestinationRouteOne = MyBusMarkerFactory.createBusStopDestinationMarker(firstRoute.getLastLatLng(), address: MyBusTitle.StopDestinationTitle.rawValue)
                roadStopsMarkerList.append(mapStopDestinationRouteOne)
                
                // Second bus
                // StopOriginRouteTwo
                let mapStopOriginRouteTwo = MyBusMarkerFactory.createBusStopOriginMarker(lastRoute.getFirstLatLng(), address: MyBusTitle.StopOriginTitle.rawValue)
               
                roadStopsMarkerList.append(mapStopOriginRouteTwo)
                
                // StopDestinationRouteTwo
                let mapStopDestinationRouteTwo = MyBusMarkerFactory.createBusStopDestinationMarker(lastRoute.getLastLatLng(), address: MyBusTitle.StopDestinationTitle.rawValue)

                roadStopsMarkerList.append(mapStopDestinationRouteTwo)
            }
        }
        
        return roadStopsMarkerList
    }
    
    class func createOriginPointMarker(coord:CLLocationCoordinate2D, address:String)->MGLAnnotation{
        let marker = MyBusMarkerAddressPoint(position: coord, title: "Origen", subtitle: address, imageIdentifier: "markerOrigen")
        return marker
    }
    
    class func createDestinationPointMarker(coord:CLLocationCoordinate2D, address:String)->MGLAnnotation{
        let marker = MyBusMarkerAddressPoint(position: coord, title: "Destino", subtitle: address, imageIdentifier: "markerDestino")
        return marker
    }
    
    class func createBusStopOriginMarker(coord:CLLocationCoordinate2D, address:String)->MGLAnnotation{
        /*
         case MyBusTitle.StopOriginTitle.rawValue:
         annotationImage =  self.mapView.getMarkerImage("stopOrigen", annotationTitle: annotationTitle)
         */
        let marker = MyBusMarkerBusStopPoint(position: coord, title: address, subtitle: "", imageIdentifier: "stopOrigen")
        return marker
    }
    
    
    class func createBusStopDestinationMarker(coord:CLLocationCoordinate2D, address:String)->MGLAnnotation{
        /*
         case MyBusTitle.StopDestinationTitle.rawValue:
         annotationImage =  self.mapView.getMarkerImage("stopDestino", annotationTitle: annotationTitle)
         */
        let marker = MyBusMarkerBusStopPoint(position: coord, title: address, subtitle: "", imageIdentifier: "stopDestino")
        return marker

    }
    
    class func createSameStartEndCompleteBusRouteMarker(){
        /*
         case ~/MyBusTitle.SameStartEndCompleteBusRoute.rawValue:
         annotationImage =  self.mapView.getMarkerImage("map_from_to_route", annotationTitle: annotationTitle)
         */
    }
    
    class func createStartCompleteBusRouteMarker(){
        /*
         case ~/MyBusTitle.StartCompleteBusRoute.rawValue:
         annotationImage =  self.mapView.getMarkerImage("stopOrigen", annotationTitle: annotationTitle)
         */
    }
    
    class func createEndCompleteBusRouteMarker(){
        /*
         case ~/MyBusTitle.EndCompleteBusRoute.rawValue:
         annotationImage =  self.mapView.getMarkerImage("stopDestino", annotationTitle: annotationTitle)
         */
    }
    
    class func createRechargePointMarker(point:RechargePoint)-> MyBusMarkerRechargePoint{
        let position = CLLocationCoordinate2DMake(point.location.latitude, point.location.longitude)
        let marker = MyBusMarkerRechargePoint(position: position, title: point.name, subtitle: point.address, imageIdentifier: "map_charge")
        return marker
    }
}

// MARK: Polyline factory methods
class MyBusPolylineFactory {
    
    class func createWalkingPathPolyline(route:MBRoute, title:String) -> MGLPolyline{
        var stepsCoordinates: [CLLocationCoordinate2D] = route.geometry
        let walkingPathPolyline = MGLPolyline(coordinates: &stepsCoordinates, count: UInt(stepsCoordinates.count))
        walkingPathPolyline.title = title
        return walkingPathPolyline
    }
    
    // busNumber:String  -> the polyline subtitle should be the bus number
    class func createBusRoutePolyline(busRoute:Route, title:String, subtitle:String? = "")->MGLPolyline{
        
        var busRouteCoordinates:[CLLocationCoordinate2D] = busRoute.pointList.map { (point:RoutePoint) -> CLLocationCoordinate2D in
            
            // Make a CLLocationCoordinate2D with the lat, lng
            return CLLocationCoordinate2DMake(Double(point.latitude)!, Double(point.longitude)!)
        }
        let busPolyline = MGLPolyline(coordinates: &busRouteCoordinates, count: UInt(busRouteCoordinates.count))
        busPolyline.title = title
        busPolyline.subtitle = subtitle
        
        return busPolyline
    }
    
    class func buildBusRoutePolylineList(roadResult:RoadResult)->[MGLPolyline]{
        
        var busRoutePolylineList:[MGLPolyline] = []
        
        // First bus route polyline
        let firstBusRoute: Route = (roadResult.routeList.first)!
        
        let firstBusLine = MyBusPolylineFactory.createBusRoutePolyline(firstBusRoute, title: MyBusTitle.BusLineRouteTitle.rawValue, subtitle: roadResult.idBusLine1)
        busRoutePolylineList.append(firstBusLine)
        
        // If road is combinated, we add second bus route polyline
        if roadResult.busRouteResultType() == .Combined
        {
            let secondBusRoute = roadResult.routeList[1]
            let secondBusLine = MyBusPolylineFactory.createBusRoutePolyline(secondBusRoute, title: MyBusTitle.BusLineRouteTitle.rawValue, subtitle: roadResult.idBusLine2)
            busRoutePolylineList.append(secondBusLine)
        }
        
        return busRoutePolylineList
    }
}


@IBDesignable
class MyBusMapView:MGLMapView{
   
    
    // This needs to be refactored
    var origin:CLLocationCoordinate2D!
    var destination:CLLocationCoordinate2D!
    
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
    
    var annotationIsRechargePointClosure:(MGLAnnotation)->Bool = { annotation in
        return (annotation is MyBusMarkerRechargePoint)
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
    
    func initialize(delegate:MGLMapViewDelegate){
        self.maximumZoomLevel = maxZoomLevel
        self.minimumZoomLevel = minZoomLevel
        self.userTrackingMode = .None
        self.delegate = delegate
    }
    
    
    func addPoint(){}
    func addRoad(){}
    func addRoute(){}
    func centerMapWithGPSLocation(){}
    
    func addRechargePoints(rechargePoints: [RechargePoint]) -> Void {
        
        let rechargePointAnnotations = rechargePoints.map { (point:RechargePoint) -> MyBusMarkerRechargePoint in
            return MyBusMarkerFactory.createRechargePointMarker(point)
        }
        self.addAnnotations(rechargePointAnnotations)
        self.fitToAnnotationsInMap()
    
    }
    
    func getMarkerImage(imageResourceIdentifier: String, annotationTitle: String) -> MGLAnnotationImage {
        var image = UIImage(named: imageResourceIdentifier)!
        image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
        return MGLAnnotationImage(image: image, reuseIdentifier: annotationTitle)
    }

    
    // MARK: - Mapview bus roads manipulation Methods
    
    func displayCompleteBusRoute(route: CompleteBusRoute) -> Void {
        clearExistingBusRoadAnnotations()
        clearExistingBusRouteAnnotations()
        
        //let bounds = getOriginAndDestinationInMapsBounds((route.goingPointList.first?.getLatLong())!, secondPoint: (route.returnPointList.first?.getLatLong())!)
        
        //self.setVisibleCoordinateBounds(bounds, animated: true)
        
        for marker in route.getMarkersAnnotation() {
            self.addAnnotation(marker)
        }
        
        for polyline in route.getPolyLines() {
            self.addAnnotation(polyline)
        }
    }
        
    
    func addBusRoad(roadResult: RoadResult) {        
        let walkingRoutes = roadResult.walkingRoutes
        
        //let bounds = getOriginAndDestinationInMapsBounds(self.destination!, secondPoint: self.origin!)
        
        clearExistingBusRoadAnnotations()
        
        //self.setVisibleCoordinateBounds(bounds, animated: true)
        
        for walkingRoute in walkingRoutes {
            let walkingPolyline = MyBusPolylineFactory.createWalkingPathPolyline(walkingRoute, title:MyBusTitle.WalkingPathTitle.rawValue)
            self.addAnnotation(walkingPolyline)
        }
        
        let roadStopsMarkerList = MyBusMarkerFactory.buildBusRoadStopMarkers(roadResult)
        for marker in roadStopsMarkerList {
            self.addAnnotation(marker)
        }
        
        let busRoutePolylineList = MyBusPolylineFactory.buildBusRoutePolylineList(roadResult)
        for polyline in busRoutePolylineList {
            self.addAnnotation(polyline)
        }
    }
        
    func addOriginPosition(origin: CLLocationCoordinate2D, address: String) {        
        self.clearAllAnnotations()
        
        self.origin = origin
        // Declare the marker point and set its coordinates
        let originMarker = MyBusMarkerFactory.createOriginPointMarker(origin, address: address)
        
        self.addAnnotation(originMarker)
        self.setCenterCoordinate(origin, animated: true)
    }
    
    func addDestinationPosition(destination: CLLocationCoordinate2D, address: String) {
        self.destination = destination
        
        // Declare the marker point and set its coordinates
        let destinationMarker = MyBusMarkerFactory.createDestinationPointMarker(destination, address: address)
        
        //let bounds = getOriginAndDestinationInMapsBounds(self.destination!, secondPoint: self.origin!)
        //self.setVisibleCoordinateBounds(bounds, animated:true)
        self.addAnnotation(destinationMarker)
        self.fitToAnnotationsInMap()
       
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
    
    func clearRechargePointAnnotations(){
        self.clearAnnotations(annotationIsRechargePointClosure)
    }
    
    private func clearAnnotations(criteriaClosure:((MGLAnnotation)->Bool)? = nil){
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
