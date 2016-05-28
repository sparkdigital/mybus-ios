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

private let mapboxAccessToken = "pk.eyJ1Ijoibm9zb3VsODgiLCJhIjoiY2lteGt2dHhsMDNrNXZxbHU0M29mcHZnZiJ9.MMbmK9GfcdhpDw2siu0wuA"

private let municipalityAccessToken = "rwef3253465htrt546dcasadg4343"

private let googleGeocodingApiKey = "AIzaSyCXgPZbEkpO_KsQqr5_q7bShcOhRlvodyc"

private let municipalityBaseURL = "http://gis.mardelplata.gob.ar/opendata/ws.php?method=rest"

private let googleMapsGeocodingBaseURL = "https://maps.googleapis.com/maps/api/geocode/json?"

private let streetNamesEndpointURL = "\(municipalityBaseURL)&endpoint=callejero_mgp&token=\(municipalityAccessToken)&nombre_calle="

private let addressToCoordinateEndpointURL = "\(municipalityBaseURL)&endpoint=callealtura_coordenada&token=\(municipalityAccessToken)"

private let coordinateToAddressEndpointURL = "\(municipalityBaseURL)&endpoint=coordenada_calleaaltura&token=\(municipalityAccessToken)"


public class Connectivity: NSObject
{

    // MARK: - Instantiation
    public class var sharedInstance: Connectivity
    {
        return _sharedInstance
    }

    override init() { }

    // MARK: Municipality Endpoints
    func getStreetNames(forName address: String, completionHandler: ([Street]?, NSError?) -> ())
    {
        let escapedStreet = address.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())! as String
        let streetNameURLString = "\(streetNamesEndpointURL)\(escapedStreet)"

        let request = NSMutableURLRequest(URL: NSURL(string: streetNameURLString)!)
        request.HTTPMethod = "GET"

        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .Success(let value):
                var streetsNames : [Street] = [Street]()
                let json = JSON(value)
                if let streets = json.array {
                    for street in streets {
                        streetsNames.append(Street(json: street))
                    }
                }
                completionHandler(streetsNames, nil)
            case .Failure(let error):
                print("\nError: \(error)")
                completionHandler(nil, error)
            }
        }
    }

    public func getCoordinateFromAddress(streetName : String, completionHandler: (JSON?, NSError?) -> ())
    {
        print("Address to resolve geocoding: \(streetName)")
        let address = "\(streetName), mar del plata"
        var coordinateFromAddressURLString = "\(googleMapsGeocodingBaseURL)&address=\(address)&components=administrative_area:General Pueyrredón&key=\(googleGeocodingApiKey)"
        coordinateFromAddressURLString = coordinateFromAddressURLString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())! as String
        let request = NSMutableURLRequest(URL: NSURL(string: coordinateFromAddressURLString)!)
        request.HTTPMethod = "GET"

        Alamofire.request(request).responseJSON { response in
            switch response.result
            {
            case .Success(let value):
                let json = JSON(value)
                completionHandler(json, nil)
            case .Failure(let error):
                print("\nError: \(error)")
                completionHandler(nil, error)
            }
        }
    }

    public func getAddressFromCoordinate(latitude : Double, longitude: Double, completionHandler: (NSDictionary?, NSError?) -> ())
    {
        print("You tapped at: \(latitude), \(longitude)")
        let addressFromCoordinateURLString = "\(coordinateToAddressEndpointURL)&latitud=\(latitude)&longitud=\(longitude)"

        let request = NSMutableURLRequest(URL: NSURL(string: addressFromCoordinateURLString)!)
        request.HTTPMethod = "GET"

        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .Success(let value):
                completionHandler(value as? NSDictionary, nil)
            case .Failure(let error):
                completionHandler(nil, error)
            }
        }
    }

    // MARK: MyBus Endpoints
    func getBusLinesFromOriginDestination(latitudeOrigin : Double, longitudeOrigin : Double, latitudeDestination : Double, longitudeDestination : Double, completionHandler : ([BusRouteResult]?, NSError?) -> ())
    {
        myBusService.searchRoutes(latitudeOrigin, longitudeOrigin: longitudeOrigin, latitudeDestination: latitudeDestination, longitudeDestination: longitudeDestination, completionHandler: completionHandler)
    }

    func getSingleResultRoadApi(idFirstLine : Int, firstDirection : Int, beginStopFirstLine: Int, endStopFirstLine : Int, completionHandler : (RoadResult?, NSError?) -> ())
    {
        let singleRoadSearch =  RoadSearch(singleRoad: idFirstLine, firstDirection: firstDirection, beginStopFirstLine: beginStopFirstLine, endStopFirstLine: endStopFirstLine)
        myBusService.searchRoads(.Single , roadSearch: singleRoadSearch, completionHandler: completionHandler)
    }

    func getCombinedResultRoadApi(idFirstLine : Int, idSecondLine : Int, firstDirection : Int, secondDirection: Int, beginStopFirstLine: Int, endStopFirstLine : Int, beginStopSecondLine: Int, endStopSecondLine : Int, completionHandler : (RoadResult?, NSError?) -> ())
    {
        let singleRoadSearch =  RoadSearch(combinedRoad: idFirstLine, firstDirection: firstDirection, beginStopFirstLine: beginStopFirstLine, endStopFirstLine: endStopFirstLine, idSecondLine: idSecondLine, secondDirection: secondDirection, beginStopSecondLine: beginStopSecondLine, endStopSecondLine: endStopSecondLine)
        myBusService.searchRoads(.Combined, roadSearch: singleRoadSearch, completionHandler: completionHandler)
    }

    func getWalkingDirections(sourceCoordinate : CLLocationCoordinate2D, destinationCoordinate : CLLocationCoordinate2D, completionHandler : (MBDirectionsResponse?, NSError?) -> ())
    {
        let walkingToDestinationDirectionsRequest = MBDirectionsRequest(sourceCoordinate: sourceCoordinate, destinationCoordinate: destinationCoordinate)
        walkingToDestinationDirectionsRequest.transportType = .Walking

        let destinationDirections = MBDirections(request: walkingToDestinationDirectionsRequest, accessToken: mapboxAccessToken)
        destinationDirections.calculateDirectionsWithCompletionHandler {
            response, error in
            completionHandler(response, error)
        }

    }

}
