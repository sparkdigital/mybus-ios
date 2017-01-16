//
//  BaseNetworkService.swift
//  MyBus
//
//  Created by Lisandro Falconi on 5/29/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum GeoCodingRouter: URLRequestConvertible{

    static let GEO_CODING_URL: String = Configuration.googleGeocodingURL()
    static let GEO_CODING_API_KEY: String = Configuration.googleGeocodingAPIKey()

    case coordinateFromAddressComponents(address:String, components:String, key:String)

    // MARK: URLRequestConvertible

    func asURLRequest() throws -> URLRequest {
        let (path, parameters, method): (String, Parameters, String) = {
            switch self {
            case .coordinateFromAddressComponents(let address, let components, let key):
                let params: Parameters = ["address":address, "components":components, "key":key]
                return ("/json", params, "GET")
            }
        }()

        let url = try GeoCodingRouter.GEO_CODING_URL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method

        return try URLEncoding.default.encode(urlRequest, with: parameters)
    }
}

enum MyBusRouter: URLRequestConvertible{

    static let MYBUS_BASE_URL: String = Configuration.myBusApiUrl()
    static let MYBUS_ACCESS_TOKEN: String = Configuration.myBusApiKey()

    /*
     //Search Routes method
     //Params:
     // - AvailableBusLines api url = NexusApi.php
     // - latitudeOrigin
     // - longitudeOrigin
     // - latitudeDestination
     // - longitudeDestination
     // - myBusAccessToken
     */
    case searchRoutes(latOrigin:Double, lngOrigin:Double, latDest:Double, lngDest:Double, accessToken:String)


    /*
     //Search Roads (single)
     //Params:
     // - singleResultRoadEndpoint api url = SingleRoadApi.php
     // - idline    (firstline)
     // - direction (firstDirection)
     // - stop1     (beginStopFirstLine)
     // - stop2     (endStopFirstLine)
     // - tk        (myBusAccessToken)
     */
    case searchSingleRoad(idLine:Int, direction:Int, beginStopLine:Int, endStopLine:Int, accessToken:String)

    /*
     //Search Roads (combined)
     //Params:
     // - combinedResultRoadEndpoint api url = CombinedRoadApi.php
     // - idline1    (idfirstline)
     // - idline2    (idsecondline)
     // - direction1 (firstDirection)
     // - direction2 (secondDirection)
     // - L1stop1    (beginStopFirstLine)
     // - L1stop2    (endStopFirstLine)
     // - L2stop1    (beginStopSecondLine)
     // - L2stop2    (endStopSecondLine)
     // - tk         (myBusAccessToken)
     */
    case searchCombinedRoad(idFirstLine:Int, idSecondLine:Int, firstDirection:Int, secondDirection:Int, beginStopFirstLine:Int, endStopFirstLine:Int, beginStopSecondLine:Int, endStopSecondLine:Int, accessToken:String)

    /*
     //No methods yet
     private let rechargeCardPointsEndpointURL = "\(myBusBaseURL)RechargeCardPointApi.php?"
    */
    case rechargeCardPoints(latitude: Double, longitude: Double, accessToken: String)

    /*
     //Complete Roads
     //Params:
     // - completeRoads api url = CompleteRoadsApi.php
     // - idline1   (idLine)
     // - direction (direction)
     // - tk        (myBusAccessToken)
    */
    case completeRoads(idLine: Int, direction: Int, accessToken: String)


    // MARK: URLRequestConvertible

    func asURLRequest() throws -> URLRequest {
        let (path, parameters, method): (String, Parameters, String) = {

            switch self{

            case .searchRoutes(let latOrigin, let lngOrigin, let latDest, let lngDest, let accessToken):

                var params: Parameters = [:]
                params["lat0"] = latOrigin
                params["lng0"] = lngOrigin
                params["lat1"] = latDest
                params["lng1"] = lngDest
                params["tk"]   = accessToken

                return ("NexusApi.php", params, "GET")

            case .searchSingleRoad(let idLine, let direction, let beginStopLine, let endStopLine, let accessToken):

                var params: Parameters = [:]
                params["idline"]    = idLine
                params["direction"] = direction
                params["stop1"]     = beginStopLine
                params["stop2"]     = endStopLine
                params["tk"]        = accessToken

                return ("SingleRoadApi.php", params, "GET")

            case .searchCombinedRoad(let idFirstLine, let idSecondLine, let firstDirection, let secondDirection, let beginStopFirstLine, let endStopFirstLine, let beginStopSecondLine, let endStopSecondLine, let accessToken):

                var params: Parameters = [:]
                params["idline1"] = idFirstLine
                params["idline2"] = idSecondLine
                params["direction1"] = firstDirection
                params["direction2"] = secondDirection
                params["L1stop1"] = beginStopFirstLine
                params["L1stop2"] = endStopFirstLine
                params["L2stop1"] = beginStopSecondLine
                params["L2stop2"] = endStopSecondLine
                params["tk"] = accessToken

                return ("CombinedRoadApi.php", params, "GET")

            case .rechargeCardPoints(let latitude, let longitude, let accessToken):

                var params: Parameters = [:]
                params["lat"] = latitude
                params["lng"] = longitude
                params["tk"] = accessToken
                params["ra"] = 1 as AnyObject? // the radius of search // Temporarily disabled.

                return ("RechargeCardPointApi.php", params, "GET")

            case .completeRoads(let idLine, let direction, let accessToken):
                var params: Parameters = [:]
                params["idline"]    = idLine
                params["direction"] = direction
                params["tk"] = accessToken

                return ("CompleteRoadsApi.php", params, "GET")

            }

        }()

        let url = try MyBusRouter.MYBUS_BASE_URL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method

        return try URLEncoding.default.encode(urlRequest, with: parameters)
    }
}



class BaseNetworkService{


    class func performRequest(_ urlString: String, completionHandler: @escaping (JSON?, Error?) -> Void) {
        Alamofire.request(urlString).responseJSON { response in
            switch response.result
            {
            case .success(let value):
                let json = JSON(value)
                completionHandler(json, nil)
            case .failure(let error):
                print("\nError: \(error)")
                completionHandler(nil, error)
            }
        }
    }

    class func performRequest(_ request: URLRequest, completionHandler: @escaping (JSON?, Error?)->Void){

        Alamofire.request(request).responseJSON { response in
            switch response.result
            {
            case .success(let value):
                let json = JSON(value)
                completionHandler(json, nil)
            case .failure(let error):
                print("\nError: \(error)")
                completionHandler(nil, error)
            }
        }

    }
}
