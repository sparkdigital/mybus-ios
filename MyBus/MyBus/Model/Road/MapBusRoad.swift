//
//  MapBusRoad.swift
//  MyBus
//
//  Created by Lisandro Falconi on 5/9/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import Mapbox

class MapBusRoad: NSObject {
    var markerList : [MGLPointAnnotation] = [MGLPointAnnotation]()
    var polyLineList : [MGLPolyline] = [MGLPolyline]()
    
    func addBusRoadOnMap(roadResult : RoadResult) -> MapBusRoad
    {
        if(roadResult.roadResultType == 0)
        {
            // Declare the marker point and set its coordinates
            let mapPoint = MGLPointAnnotation()
            mapPoint.coordinate = (roadResult.routeList.first?.getFirstLatLng())!
            mapPoint.title = "Origen"
            markerList.append(mapPoint)
            
            let mapPoint2 = MGLPointAnnotation()
            mapPoint2.coordinate = (roadResult.routeList.last?.getLastLatLng())!
            mapPoint2.title = "Destino"
            markerList.append(mapPoint2)
        } else {
            //TODO
        }
        
        
        let route : Route = (roadResult.routeList.first)!
        var coordinates: [CLLocationCoordinate2D] = []

        for point in route.pointList {
            // Make a CLLocationCoordinate2D with the lat, lng
            let coordinate = CLLocationCoordinate2DMake(Double(point.latitude)!, Double(point.longitude)!)
            // Add coordinate to coordinates array
            coordinates.append(coordinate)
        }
        let line = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
        line.title = "Crema to Council Crest"
        polyLineList.append(line)
    
        coordinates = []
        if (roadResult.roadResultType == 1) {
            let route = roadResult.routeList[1];
            for point in route.pointList {
                // Make a CLLocationCoordinate2D with the lat, lng
                let coordinate = CLLocationCoordinate2DMake(Double(point.latitude)!, Double(point.longitude)!)
                // Add coordinate to coordinates array
                coordinates.append(coordinate)
            }
            let line2 = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))

            line2.title = "222222"
            polyLineList.append(line2)
        }
        
        return self;
    }
    
    func clearBusRoadFromMap() -> Void {
//        for (Marker marker : mMarkerList) {
//            marker.remove();
//        }
//        for (Polyline polyline : mPolylineList) {
//            polyline.remove();
//        }
//        mMarkerList.clear();
//        mPolylineList.clear();
    }
    
    func showBusRoadFromMap(show : Bool) -> Void {
//        for (Marker marker : mMarkerList) {
//            marker.setVisible(show);
//        }
//        for (Polyline polyline : mPolylineList) {
//            polyline.setVisible(show);
//        }
    }
}