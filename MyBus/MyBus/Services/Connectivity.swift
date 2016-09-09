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

public class Connectivity: NSObject
{

    // MARK: - Instantiation
    public class var sharedInstance: Connectivity
    {
        return _sharedInstance
    }

    override init() { }

    // MARK: Municipality Endpoints
    func getStreetNames(forName address: String, completionHandler: ([String]?, NSError?) -> ())
    {
        mgpGisService.getStreetNamesByFile(forName: address, completionHandler: completionHandler)
    }

    public func getAddressFromCoordinate(latitude: Double, longitude: Double, completionHandler: (JSON?, NSError?) -> ())
    {
        mgpGisService.getAddressFromCoordinate(latitude, longitude : longitude, completionHandler : completionHandler)
    }

    // MARK - Google Geocoding Endpoint
    func getCoordinateFromAddress(streetName: String, completionHandler: (RoutePoint?, NSError?) -> ())
    {
        googleGeocodingService.getCoordinateFromAddress(streetName, completionHandler : completionHandler)
    }

    // MARK: MyBus Endpoints
    func getBusLinesFromOriginDestination(latitudeOrigin: Double, longitudeOrigin: Double, latitudeDestination: Double, longitudeDestination: Double, completionHandler: ([BusRouteResult]?, NSError?) -> ())
    {
        myBusService.searchRoutes(latitudeOrigin, longitudeOrigin: longitudeOrigin, latitudeDestination: latitudeDestination, longitudeDestination: longitudeDestination, completionHandler: completionHandler)
    }

    func getSingleResultRoadApi(idFirstLine: Int, firstDirection: Int, beginStopFirstLine: Int, endStopFirstLine: Int, completionHandler: (RoadResult?, NSError?) -> ())
    {
        let singleRoadSearch =  RoadSearch(singleRoad: idFirstLine, firstDirection: firstDirection, beginStopFirstLine: beginStopFirstLine, endStopFirstLine: endStopFirstLine)
        myBusService.searchRoads(.Single, roadSearch: singleRoadSearch, completionHandler: completionHandler)
    }

    func getCombinedResultRoadApi(idFirstLine: Int, idSecondLine: Int, firstDirection: Int, secondDirection: Int, beginStopFirstLine: Int, endStopFirstLine: Int, beginStopSecondLine: Int, endStopSecondLine: Int, completionHandler: (RoadResult?, NSError?) -> ())
    {
        let combinedRoadSearch =  RoadSearch(combinedRoad: idFirstLine, firstDirection: firstDirection, beginStopFirstLine: beginStopFirstLine, endStopFirstLine: endStopFirstLine, idSecondLine: idSecondLine, secondDirection: secondDirection, beginStopSecondLine: beginStopSecondLine, endStopSecondLine: endStopSecondLine)
        myBusService.searchRoads(.Combined, roadSearch: combinedRoadSearch, completionHandler: completionHandler)
    }

    func getCompleteRoads(idLine: Int, direction: Int, completionHanlder: (CompleteBusRoute?, NSError?)->())
    {
        myBusService.getCompleteRoads(idLine, direction: direction, completionHandler: completionHanlder)
    }

    // MARK - Directions Endpoints
    func getWalkingDirections(sourceCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D, completionHandler: (MBDirectionsResponse?, NSError?) -> ())
    {
        directionsService.getWalkingDirections(sourceCoordinate, destinationCoordinate : destinationCoordinate, completionHandler : completionHandler)
    }

}
