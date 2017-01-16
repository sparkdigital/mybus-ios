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

    class func buildGoingBusRouteStopMarkers(_ busRoute: CompleteBusRoute) -> [MyBusMarker] {
        let goingPointList = busRoute.goingPointList
        var markers: [MyBusMarker] = []

        guard let startGoingPoint = goingPointList.first, let endGoingPoint = goingPointList.last else {
            return markers
        }

        let startGoingMarker = MyBusMarkerFactory.createStartCompleteBusRouteMarker(startGoingPoint.getLatLong(), address: startGoingPoint.address, busLineName: busRoute.busLineName)
        markers.append(startGoingMarker)
        //Add END of GOING route
        let endGoingMarker = MyBusMarkerFactory.createEndCompleteBusRouteMarker(endGoingPoint.getLatLong(), address: endGoingPoint.address, busLineName: busRoute.busLineName)
        markers.append(endGoingMarker)
        return markers
    }

    class func buildReturnBusRouteStopMarkers(_ busRoute: CompleteBusRoute) -> [MyBusMarker] {
        let returnPointList = busRoute.returnPointList
        var markers: [MyBusMarker] = []

        guard let startReturnPoint = returnPointList.first, let endReturnPoint = returnPointList.last else {
            return markers
        }
        let startReturnMarker = MyBusMarkerFactory.createStartCompleteBusRouteMarker(startReturnPoint.getLatLong(), address: startReturnPoint.address, busLineName: busRoute.busLineName)
        markers.append(startReturnMarker)
        //Add END of RETURN route
        let endReturnMarker = MyBusMarkerFactory.createEndCompleteBusRouteMarker(endReturnPoint.getLatLong(), address: endReturnPoint.address, busLineName: busRoute.busLineName)
        markers.append(endReturnMarker)
        return markers
    }

    class func buildCompleteBusRoadStopMarkers(_ completeBusRoute: CompleteBusRoute) -> [MyBusMarker] {
        var markers: [MyBusMarker] = []
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

    class func buildBusRoadStopMarkers(_ roadResult: RoadResult)->[MyBusMarker]{

        var roadStopsMarkerList: [MyBusMarker] = []

        let busRouteType: MyBusRouteResultType = roadResult.busRouteResultType()

        if let firstRoute = roadResult.routeList.first, let lastRoute = roadResult.routeList.last {
            guard let stopOrigin = firstRoute.pointList.first, let stopDestination = firstRoute.pointList.last else {
                return roadStopsMarkerList
            }
            switch busRouteType {
            case .single:
                guard let stopOriginCoordinate = firstRoute.getFirstLatLng() else {
                    break
                }
                let stopOriginMapPoint = MyBusMarkerFactory.createBusStopOriginMarker(stopOriginCoordinate, address: stopOrigin.address)
                roadStopsMarkerList.append(stopOriginMapPoint)

                guard let stopDestionationCoordinate = firstRoute.getLastLatLng() else {
                    break
                }
                let stopDestinationMapPoint = MyBusMarkerFactory.createBusStopDestinationMarker(stopDestionationCoordinate, address: stopDestination.address)
                roadStopsMarkerList.append(stopDestinationMapPoint)

            case .combined:
                guard let secondBusStopOrigin = lastRoute.pointList.first, let secondBusStopDestination = lastRoute.pointList.last else {
                    break
                }
                //First bus
                // StopOriginRouteOne
                guard let firstStopOriginCoordinate = firstRoute.getFirstLatLng(), let firstStopDestionationCoordinate = firstRoute.getLastLatLng() else {
                    break
                }
                let mapStopOriginRouteOne = MyBusMarkerFactory.createBusStopOriginMarker(firstStopOriginCoordinate, address: stopOrigin.address)
                roadStopsMarkerList.append(mapStopOriginRouteOne)

                // StopDestinationRouteOne
                let mapStopDestinationRouteOne = MyBusMarkerFactory.createBusStopDestinationMarker(firstStopDestionationCoordinate, address: stopDestination.address)
                roadStopsMarkerList.append(mapStopDestinationRouteOne)

                // Second bus
                // StopOriginRouteTwo
                guard let secondStopOriginCoordinate = lastRoute.getFirstLatLng(), let secondStopDestionationCoordinate = lastRoute.getLastLatLng() else {
                    break
                }
                let mapStopOriginRouteTwo = MyBusMarkerFactory.createBusStopOriginMarker(secondStopOriginCoordinate, address: secondBusStopOrigin.address)

                roadStopsMarkerList.append(mapStopOriginRouteTwo)

                // StopDestinationRouteTwo
                let mapStopDestinationRouteTwo = MyBusMarkerFactory.createBusStopDestinationMarker(secondStopDestionationCoordinate, address: secondBusStopDestination.address)

                roadStopsMarkerList.append(mapStopDestinationRouteTwo)
            }
        }

        return roadStopsMarkerList
    }

    class func buildIntermediateBusStopMarkers(_ roadResult: RoadResult)->[MyBusMarkerIntermediateBusStopPoint] {

        //Get Points
        var busStopRoutePoints = roadResult.getPointList()

        // The user has elected origin and destination very close between them
        if busStopRoutePoints.count < 3 {
            return []
        }

        //Filter waypoints
        busStopRoutePoints = busStopRoutePoints.filter { (busStopPoint) -> Bool in
            return busStopPoint.isWaypoint == false
        }

        //Init markers array
        var routeBusStops: [MyBusMarkerIntermediateBusStopPoint] = busStopRoutePoints.map { (busStopPoint) -> MyBusMarkerIntermediateBusStopPoint in
            return MyBusMarkerFactory.createRoadBusStopMarker(busStopPoint)
        }

        //Remove destination stop
        routeBusStops.removeLast()

        //Remove origin stop
        routeBusStops.removeFirst()

        return routeBusStops

    }

    class func createOriginPointMarker(_ point: RoutePoint)->MyBusMarkerOriginPoint {
        let marker = MyBusMarkerOriginPoint(position: point.getLatLong(), title: MyBusTitle.OriginTitle.rawValue, subtitle: point.address, imageIdentifier: "markerOrigen")
        return marker
    }

    class func createDestinationPointMarker(_ point: RoutePoint)->MyBusMarkerDestinationPoint {
        let marker = MyBusMarkerDestinationPoint(position: point.getLatLong(), title: MyBusTitle.DestinationTitle.rawValue, subtitle: point.address, imageIdentifier: "markerDestino")
        return marker
    }

    class func createRoadBusStopMarker(_ point: RoutePoint) -> MyBusMarkerIntermediateBusStopPoint{
        let marker = MyBusMarkerIntermediateBusStopPoint(position: point.getLatLong(), title: MyBusTitle.BusStop.rawValue, subtitle: point.address, imageIdentifier: "stop_marker")
        return marker
    }

    class func createOriginPointMarker(_ coord: CLLocationCoordinate2D, address: String)->MyBusMarkerOriginPoint{
        let marker = MyBusMarkerOriginPoint(position: coord, title: MyBusTitle.OriginTitle.rawValue, subtitle: address, imageIdentifier: "markerOrigen")
        return marker
    }

    class func createDestinationPointMarker(_ coord: CLLocationCoordinate2D, address: String)->MyBusMarkerDestinationPoint{
        let marker = MyBusMarkerDestinationPoint(position: coord, title: MyBusTitle.DestinationTitle.rawValue, subtitle: address, imageIdentifier: "markerDestino")
        return marker
    }

    class func createBusStopOriginMarker(_ coord: CLLocationCoordinate2D, address: String)->MyBusMarker{
        let marker = MyBusMarkerBusStopPoint(position: coord, title: MyBusTitle.StopOriginTitle.rawValue, subtitle: address, imageIdentifier: "stopOrigen")
        return marker
    }


    class func createBusStopDestinationMarker(_ coord: CLLocationCoordinate2D, address: String)->MyBusMarkerBusStopPoint{
        let marker = MyBusMarkerBusStopPoint(position: coord, title: MyBusTitle.StopDestinationTitle.rawValue, subtitle: address, imageIdentifier: "stopDestino")
        return marker
    }

    class func createSameStartEndCompleteBusRouteMarker(_ coord: CLLocationCoordinate2D, address: String, busLineName: String)->MyBusMarker{
        let sameStartEndTitle = "\(MyBusTitle.SameStartEndCompleteBusRoute.rawValue) \(busLineName)"

        let marker = MyBusMarkerSameStartEndCompleteRoutePoint(position: coord, title: sameStartEndTitle, subtitle: address, imageIdentifier: "map_from_to_route")
        return marker
    }

    class func createStartCompleteBusRouteMarker(_ coord: CLLocationCoordinate2D, address: String, busLineName: String)->MyBusMarker{
        let startTitle = "\(MyBusTitle.StartCompleteBusRoute.rawValue) \(busLineName)"

        let marker = MyBusMarkerBusStopPoint(position: coord, title: startTitle, subtitle: address, imageIdentifier: "stopOrigen")
        return marker
    }

    class func createEndCompleteBusRouteMarker(_ coord: CLLocationCoordinate2D, address: String, busLineName: String)->MyBusMarker{
        let endTitle = "\(MyBusTitle.EndCompleteBusRoute.rawValue) \(busLineName)"
        let marker = MyBusMarkerBusStopPoint(position: coord, title: endTitle, subtitle: address, imageIdentifier: "stopDestino")
        return marker
    }

    class func createRechargePointMarker(_ point: RechargePoint)-> MyBusMarkerRechargePoint{
        let marker = MyBusMarkerRechargePoint(position: point.getLatLong(), title: point.address, subtitle: point.openTime, imageIdentifier: point.isOpen ? "map_charge" : "map_charge_close")
        return marker
    }
}
