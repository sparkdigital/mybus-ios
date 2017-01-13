//
//  Connectivity.swift
//  MyBus
//
//  Created by Marcos Vivar on 4/13/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Alamofire
import SwiftyJSON
import MapboxDirections
import Mapbox

private let _sharedInstance = Connectivity()

private let myBusService = MyBusService()
private let directionsService = MapBoxDirectionsService()
private let mgpGisService = GisService()
private let googleGeocodingService = GeoCodingService()

open class Connectivity: NSObject
{

    // MARK: - Instantiation
    open class var sharedInstance: Connectivity
    {
        return _sharedInstance
    }

    override init() { }

    // MARK: - Municipality Endpoints
    func getStreetNames(forName address: String, completionHandler: ([String]?, Error?) -> ())
    {
        mgpGisService.getStreetNamesByFile(forName: address, completionHandler: completionHandler)
    }
    
    func getAllStreetNames(_ completionHandler: ([String]?, Error?) -> ())
    {
        mgpGisService.getAllStreetNamesByFile(completionHandler)
    }

    func getAddressFromCoordinate(_ latitude: Double, longitude: Double, completionHandler: @escaping (RoutePoint?, Error?) -> ())
    {
        mgpGisService.getAddressFromCoordinate(latitude, longitude : longitude, completionHandler : completionHandler)
    }

    // MARK: - Google Geocoding Endpoint
    func getCoordinateFromAddress(_ streetName: String, completionHandler: @escaping (RoutePoint?, Error?) -> ())
    {
        googleGeocodingService.getCoordinateFromAddress(streetName, completionHandler : completionHandler )
    }

    // MARK: - MyBus Endpoints
    func getBusLinesFromOriginDestination(_ latitudeOrigin: Double, longitudeOrigin: Double, latitudeDestination: Double, longitudeDestination: Double, completionHandler: @escaping ([BusRouteResult]?, Error?) -> ())
    {
        myBusService.searchRoutes(latitudeOrigin, longitudeOrigin: longitudeOrigin, latitudeDestination: latitudeDestination, longitudeDestination: longitudeDestination, completionHandler: completionHandler)
    }

    func getSingleResultRoadApi(_ idFirstLine: Int, firstDirection: Int, beginStopFirstLine: Int, endStopFirstLine: Int, completionHandler: @escaping (RoadResult?, Error?) -> ())
    {
        let singleRoadSearch =  RoadSearch(singleRoad: idFirstLine, firstDirection: firstDirection, beginStopFirstLine: beginStopFirstLine, endStopFirstLine: endStopFirstLine)
        myBusService.searchRoads(.single, roadSearch: singleRoadSearch, completionHandler: completionHandler)
    }

    func getCombinedResultRoadApi(_ idFirstLine: Int, idSecondLine: Int, firstDirection: Int, secondDirection: Int, beginStopFirstLine: Int, endStopFirstLine: Int, beginStopSecondLine: Int, endStopSecondLine: Int, completionHandler: @escaping (RoadResult?, Error?) -> ())
    {
        let combinedRoadSearch =  RoadSearch(combinedRoad: idFirstLine, firstDirection: firstDirection, beginStopFirstLine: beginStopFirstLine, endStopFirstLine: endStopFirstLine, idSecondLine: idSecondLine, secondDirection: secondDirection, beginStopSecondLine: beginStopSecondLine, endStopSecondLine: endStopSecondLine)
        myBusService.searchRoads(.combined, roadSearch: combinedRoadSearch, completionHandler: completionHandler)
    }

    func getCompleteRoads(_ idLine: Int, direction: Int, completionHandler: @escaping (CompleteBusRoute?, Error?)->())
    {
        myBusService.getCompleteRoads(idLine, direction: direction, completionHandler: completionHandler)
    }

    func getRechargeCardPoints(_ latitude: Double, longitude: Double, completionHandler: @escaping ([RechargePoint]?, Error?) -> ())
    {
        myBusService.getRechargeCardPoints(latitude, longitude: longitude, completionHandler: completionHandler)
    }

    // MARK: - Directions Endpoints
    func getWalkingDirections(_ sourceCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D, completionHandler: @escaping (MapboxDirections.Route?, Error?) -> ())
    {
        directionsService.getWalkingDirections(sourceCoordinate, destinationCoordinate : destinationCoordinate, completionHandler : completionHandler)
    }

}
