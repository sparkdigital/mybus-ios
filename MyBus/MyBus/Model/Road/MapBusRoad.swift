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
    var roadStopsMarkerList: [MGLPointAnnotation] = [MGLPointAnnotation]()
    var busRoutePolylineList: [MGLPolyline] = [MGLPolyline]()

    func addBusRoadOnMap(roadResult: RoadResult) -> MapBusRoad
    {
        addRoadMarkers(roadResult)
        addBusRoutePolyline(roadResult)
        return self
    }


    func addBusRoutePolyline(roadResult: RoadResult) -> Void {
        // First bus route polyline
        let firstBusRoute: Route = (roadResult.routeList.first)!
        let firstBusLine = busPolylineBuilder(firstBusRoute)
        busRoutePolylineList.append(firstBusLine)

        // If road is combinated, we add second bus route polyline
        if roadResult.busRouteResultType() == .Combined
        {
            let secondBusRoute = roadResult.routeList[1]
            let secondBusLine = busPolylineBuilder(secondBusRoute)
            busRoutePolylineList.append(secondBusLine)
        }
    }

    func addRoadMarkers(roadResult: RoadResult) -> Void {
        let busRouteType: MyBusRouteResultType = roadResult.busRouteResultType()

        if let firstRoute = roadResult.routeList.first, let lastRoute = roadResult.routeList.last {
            switch busRouteType {
            case .Single:
                let busRoute = firstRoute
                let stopOriginCoordinates = busRoute.getFirstLatLng()
                let stopOriginMapPoint = annotationBuilder(stopOriginCoordinates, annotationTitle: MyBusTitle.StopOriginTitle.rawValue)
                roadStopsMarkerList.append(stopOriginMapPoint)

                let stopDestinationCoordinates = busRoute.getLastLatLng()
                let stopDestinationMapPoint = annotationBuilder(stopDestinationCoordinates, annotationTitle: MyBusTitle.StopDestinationTitle.rawValue)
                roadStopsMarkerList.append(stopDestinationMapPoint)
            case .Combined:
                //First bus
                let firstBusRoute = firstRoute

                let stopOriginRouteOne = firstBusRoute.getFirstLatLng()
                let mapStopOriginRouteOne = annotationBuilder(stopOriginRouteOne, annotationTitle: MyBusTitle.StopOriginTitle.rawValue)
                roadStopsMarkerList.append(mapStopOriginRouteOne)

                let stopDestinationRouteOne = firstBusRoute.getLastLatLng()
                let mapStopDestinationRouteOne = annotationBuilder(stopDestinationRouteOne, annotationTitle: MyBusTitle.StopDestinationTitle.rawValue)
                roadStopsMarkerList.append(mapStopDestinationRouteOne)

                // Second bus
                let secondBusRoute = lastRoute

                let stopOriginRouteTwo = secondBusRoute.getFirstLatLng()
                let mapStopOriginRouteTwo = annotationBuilder(stopOriginRouteTwo, annotationTitle: MyBusTitle.StopOriginTitle.rawValue)
                roadStopsMarkerList.append(mapStopOriginRouteTwo)


                let stopDestinationRouteTwo = secondBusRoute.getLastLatLng()
                let mapStopDestinationRouteTwo = annotationBuilder(stopDestinationRouteTwo, annotationTitle: MyBusTitle.StopDestinationTitle.rawValue)
                roadStopsMarkerList.append(mapStopDestinationRouteTwo)
            }
        }
    }

    func annotationBuilder(coordinate: CLLocationCoordinate2D, annotationTitle: String) -> MGLPointAnnotation {
        let mapBoxAnnotation = MGLPointAnnotation()
        mapBoxAnnotation.coordinate = coordinate
        mapBoxAnnotation.title = annotationTitle
        return mapBoxAnnotation
    }

    func busPolylineBuilder(busRoute: Route) -> MGLPolyline {
        var busRouteCoordinates: [CLLocationCoordinate2D] = []
        for point in busRoute.pointList {
            // Make a CLLocationCoordinate2D with the lat, lng
            let coordinate = CLLocationCoordinate2DMake(Double(point.latitude)!, Double(point.longitude)!)
            // Add coordinate to coordinates array
            busRouteCoordinates.append(coordinate)
        }
        let busPolyline = MGLPolyline(coordinates: &busRouteCoordinates, count: UInt(busRouteCoordinates.count))
        busPolyline.title = MyBusTitle.BusLineRouteTitle.rawValue
        return busPolyline
    }
}
