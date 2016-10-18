//
//  MyBusMarkerFactory.swift
//  MyBus
//
//  Created by Lisandro Falconi on 10/6/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import Mapbox

class MyBusMarkerFactory {

    class func buildCompleteBusRoadStopMarkers(completeBusRoute: CompleteBusRoute) -> [MGLAnnotation] {
        var markers: [MGLAnnotation] = []
        let goingPointList = completeBusRoute.goingPointList
        let returnPointList = completeBusRoute.returnPointList

        if let startGoingPoint = goingPointList.first, let endGoingPoint = goingPointList.last {
            if let startReturnPoint = returnPointList.first, let endReturnPoint = returnPointList.last {
                //Here we have both routes loaded

                // Is the start point of going route equals end of return? Use a different icon
                let isEqualStartGoingEndReturn = completeBusRoute.isEqualStartGoingEndReturn()
                // Is the start point of return route equals end of going? Use a different icon
                let isEqualStartReturnEndGoing = completeBusRoute.isEqualStartReturnEndGoing()

                if isEqualStartGoingEndReturn {
                    let startGoingEndReturnMarker = MyBusMarkerFactory.createSameStartEndCompleteBusRouteMarker(startGoingPoint.getLatLong(), address: startGoingPoint.address, busLineName: completeBusRoute.busLineName)
                    markers.append(startGoingEndReturnMarker)
                } else {
                    let startGoingMarker = MyBusMarkerFactory.createStartCompleteBusRouteMarker(startGoingPoint.getLatLong(), address: startGoingPoint.address, busLineName: completeBusRoute.busLineName)
                    markers.append(startGoingMarker)

                    //Add END of RETURN route
                    let endReturnMarker = MyBusMarkerFactory.createEndCompleteBusRouteMarker(endReturnPoint.getLatLong(), address: endReturnPoint.address, busLineName: completeBusRoute.busLineName)
                    markers.append(endReturnMarker)
                }

                if isEqualStartReturnEndGoing {
                    let startReturnEndGoingMarker = MyBusMarkerFactory.createSameStartEndCompleteBusRouteMarker(startReturnPoint.getLatLong(), address: startReturnPoint.address, busLineName: completeBusRoute.busLineName)
                    markers.append(startReturnEndGoingMarker)
                } else {
                    let startReturnMarker = MyBusMarkerFactory.createStartCompleteBusRouteMarker(startReturnPoint.getLatLong(), address: startReturnPoint.address, busLineName: completeBusRoute.busLineName)
                    markers.append(startReturnMarker)

                    //Add END of GOING route
                    let endGoingMarker = MyBusMarkerFactory.createEndCompleteBusRouteMarker(endGoingPoint.getLatLong(), address: endGoingPoint.address, busLineName: completeBusRoute.busLineName)
                    markers.append(endGoingMarker)
                }

            } else {
                //Here we just have going route
                let startGoingMarker = MyBusMarkerFactory.createStartCompleteBusRouteMarker(startGoingPoint.getLatLong(), address: startGoingPoint.address, busLineName: completeBusRoute.busLineName)
                let endGoingMarker = MyBusMarkerFactory.createEndCompleteBusRouteMarker(endGoingPoint.getLatLong(), address: endGoingPoint.address, busLineName: completeBusRoute.busLineName)
                markers.append(startGoingMarker)
                markers.append(endGoingMarker)
            }
        }
        return markers
    }

    class func buildBusRoadStopMarkers(roadResult: RoadResult)->[MGLAnnotation]{

        var roadStopsMarkerList: [MGLAnnotation] = []

        let busRouteType: MyBusRouteResultType = roadResult.busRouteResultType()

        if let firstRoute = roadResult.routeList.first, let lastRoute = roadResult.routeList.last {
            switch busRouteType {
            case .Single:

                let stopOriginMapPoint = MyBusMarkerFactory.createBusStopOriginMarker(firstRoute.getFirstLatLng(), address: (firstRoute.pointList.first?.address)!)
                roadStopsMarkerList.append(stopOriginMapPoint)

                let stopDestinationMapPoint = MyBusMarkerFactory.createBusStopDestinationMarker(firstRoute.getLastLatLng(), address: (firstRoute.pointList.last?.address)!)
                roadStopsMarkerList.append(stopDestinationMapPoint)

            case .Combined:
                //First bus
                // StopOriginRouteOne
                let mapStopOriginRouteOne = MyBusMarkerFactory.createBusStopOriginMarker(firstRoute.getFirstLatLng(), address: (firstRoute.pointList.first?.address)!)
                roadStopsMarkerList.append(mapStopOriginRouteOne)

                // StopDestinationRouteOne
                let mapStopDestinationRouteOne = MyBusMarkerFactory.createBusStopDestinationMarker(firstRoute.getLastLatLng(), address: (firstRoute.pointList.last?.address)!)
                roadStopsMarkerList.append(mapStopDestinationRouteOne)

                // Second bus
                // StopOriginRouteTwo
                let mapStopOriginRouteTwo = MyBusMarkerFactory.createBusStopOriginMarker(lastRoute.getFirstLatLng(), address: (lastRoute.pointList.first?.address)!)

                roadStopsMarkerList.append(mapStopOriginRouteTwo)

                // StopDestinationRouteTwo
                let mapStopDestinationRouteTwo = MyBusMarkerFactory.createBusStopDestinationMarker(lastRoute.getLastLatLng(), address: (lastRoute.pointList.last?.address)!)

                roadStopsMarkerList.append(mapStopDestinationRouteTwo)
            }
        }

        return roadStopsMarkerList
    }

    class func createOriginPointMarker(coord: CLLocationCoordinate2D, address: String)->MGLAnnotation{
        let marker = MyBusMarkerOriginPoint(position: coord, title: MyBusTitle.OriginTitle.rawValue, subtitle: address, imageIdentifier: "markerOrigen")
        return marker
    }

    class func createDestinationPointMarker(coord: CLLocationCoordinate2D, address: String)->MGLAnnotation{
        let marker = MyBusMarkerDestinationPoint(position: coord, title: MyBusTitle.DestinationTitle.rawValue, subtitle: address, imageIdentifier: "markerDestino")
        return marker
    }

    class func createBusStopOriginMarker(coord: CLLocationCoordinate2D, address: String)->MGLAnnotation{
        let marker = MyBusMarkerBusStopPoint(position: coord, title: MyBusTitle.StopOriginTitle.rawValue, subtitle: address, imageIdentifier: "stopOrigen")
        return marker
    }


    class func createBusStopDestinationMarker(coord: CLLocationCoordinate2D, address: String)->MGLAnnotation{
        let marker = MyBusMarkerBusStopPoint(position: coord, title: MyBusTitle.StopDestinationTitle.rawValue, subtitle: address, imageIdentifier: "stopDestino")
        return marker
    }

    class func createSameStartEndCompleteBusRouteMarker(coord: CLLocationCoordinate2D, address: String, busLineName: String)->MGLAnnotation{
        let sameStartEndTitle = "\(MyBusTitle.SameStartEndCompleteBusRoute.rawValue) \(busLineName)"

        let marker = MyBusMarkerSameStartEndCompleteRoutePoint(position: coord, title: sameStartEndTitle, subtitle: address, imageIdentifier: "map_from_to_route")
        return marker
    }

    class func createStartCompleteBusRouteMarker(coord: CLLocationCoordinate2D, address: String, busLineName: String)->MGLAnnotation{
        let startTitle = "\(MyBusTitle.StartCompleteBusRoute.rawValue) \(busLineName)"

        let marker = MyBusMarkerBusStopPoint(position: coord, title: startTitle, subtitle: address, imageIdentifier: "stopOrigen")
        return marker
    }

    class func createEndCompleteBusRouteMarker(coord: CLLocationCoordinate2D, address: String, busLineName: String)->MGLAnnotation{
        let endTitle = "\(MyBusTitle.EndCompleteBusRoute.rawValue) \(busLineName)"
        let marker = MyBusMarkerBusStopPoint(position: coord, title: endTitle, subtitle: address, imageIdentifier: "stopDestino")
        return marker
    }

    class func createRechargePointMarker(point: RechargePoint)-> MyBusMarkerRechargePoint{
        let marker = MyBusMarkerRechargePoint(position: point.getLatLong(), title: point.name, subtitle: point.address, imageIdentifier: "map_charge")
        return marker
    }
}
