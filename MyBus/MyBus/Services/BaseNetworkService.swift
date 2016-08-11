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

enum GeoCodingRouter:URLRequestConvertible{
    
    static let GEO_CODING_URL:String = Configuration.googleGeocodingURL()
    static let GEO_CODING_API_KEY:String = Configuration.googleGeocodingAPIKey()
    
    case CoordinateFromAddressComponents(address:String, components:String, key:String)
    
    var URLRequest: NSMutableURLRequest {
        
        let (path, parameters, encoding, method): (String, [String: AnyObject], ParameterEncoding, Alamofire.Method) = {
                        
            switch self {
                case .CoordinateFromAddressComponents(let address, let components, let key):
                    let params:[String:AnyObject] = ["address":address, "components":components, "key":key]
                    return ("/json",params,.URL,.GET)
            }
        }()
        
        
        let URLRequestString = GeoCodingRouter.GEO_CODING_URL.stringByAppendingURLPath(path).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())! as String
        let URL = NSURL(string: URLRequestString)
        let URLRequest = NSMutableURLRequest(URL: URL!)
        
        URLRequest.HTTPMethod = method.rawValue
        
        return encoding.encode(URLRequest, parameters: parameters).0
        
    }
}


enum GISRouter:URLRequestConvertible{
    
    static let MUNICIPALITY_BASE_URL:String = Configuration.gisMunicipalityApiURL()
    static let MUNICIPALITY_ACCESS_TOKEN:String = Configuration.gisMunicipalityApiAccessToken()
    static let MUNICIPALITY_WS_PATH:String = Configuration.gisMunicipalityApiWebServicePath()
    static let MUNICIPALITY_WS_METHOD:String = "rest"
    
    /* streetNamesEndpointURL = "\(municipalityBaseURL)&endpoint=callejero_mgp&token=\(municipalityAccessToken)&nombre_calle=" */
    case StreetNames(street:String)
    
    /* coordinateToAddressEndpointURL = "\(municipalityBaseURL)&endpoint=coordenada_calleaaltura&token=\(municipalityAccessToken)&latitud=\(latitude)&longitud=\(longitude)"*/
    case CoordinateToAddress(latitude:Double, longitude:Double)
    
    /* addressToCoordinateEndpointURL = "\(municipalityBaseURL)&endpoint=callealtura_coordenada&token=\(municipalityAccessToken)" */
    case AddressToCoordinate(address:String)
    
    
    var URLRequest: NSMutableURLRequest {
        
        let (path, parameters, encoding, method): (String, [String: AnyObject], ParameterEncoding, Alamofire.Method) = {
            
            switch self {
                case .StreetNames(let street):
                    var params = [String:AnyObject]()
                    params["method"] = GISRouter.MUNICIPALITY_WS_METHOD
                    params["endpoint"] = "callejero_mgp"
                    params["token"] = GISRouter.MUNICIPALITY_ACCESS_TOKEN
                    params["nombre_calle"] = street
                
                    return (GISRouter.MUNICIPALITY_WS_PATH, params, .URL, .GET)
                
                case .CoordinateToAddress(let latitude, let longitude):
                    var params = [String:AnyObject]()
                    params["method"] = GISRouter.MUNICIPALITY_WS_METHOD
                    params["endpoint"] = "coordenada_calleaaltura"
                    params["token"] = GISRouter.MUNICIPALITY_ACCESS_TOKEN
                    params["latitud"] = latitude
                    params["longitud"] = longitude
                    
                    return (GISRouter.MUNICIPALITY_WS_PATH, params, .URL, .GET)
                
                case .AddressToCoordinate(let address):
                    var params = [String:AnyObject]()
                    params["method"] = GISRouter.MUNICIPALITY_WS_METHOD
                    params["endpoint"] = "callealtura_coordenada" //callealtura o calleaaltura (?)
                    params["token"] = GISRouter.MUNICIPALITY_ACCESS_TOKEN
                    //address??
                    
                    return (GISRouter.MUNICIPALITY_WS_PATH, params, .URL, .GET)
            }
            
        }()
        
        let URL = NSURL(string: GISRouter.MUNICIPALITY_BASE_URL)
        let URLRequest = NSMutableURLRequest(URL: URL!.URLByAppendingPathComponent(path))
        
        URLRequest.HTTPMethod = method.rawValue
        
        return encoding.encode(URLRequest, parameters: parameters).0
        
    }
}

enum MyBusRouter:URLRequestConvertible{
    
    static let MYBUS_BASE_URL:String = Configuration.myBusApiUrl()
    static let MYBUS_ACCESS_TOKEN:String = Configuration.myBusApiKey()
    
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
    case SearchRoutes(latOrigin:Double, lngOrigin:Double, latDest:Double, lngDest:Double, accessToken:String)
    
    
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
    case SearchSingleRoad(idLine:Int, direction:Int, beginStopLine:Int, endStopLine:Int, accessToken:String)
    
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
    case SearchCombinedRoad(idFirstLine:Int, idSecondLine:Int, firstDirection:Int, secondDirection:Int, beginStopFirstLine:Int, endStopFirstLine:Int, beginStopSecondLine:Int, endStopSecondLine:Int, accessToken:String)
    
    /*
     //No methods yet
     private let rechargeCardPointsEndpointURL = "\(myBusBaseURL)RechargeCardPointApi.php?"
    */
    case RechargeCardPoints
    
    var URLRequest: NSMutableURLRequest {
        
        
        let (path, parameters, encoding, method): (String, [String: AnyObject], ParameterEncoding, Alamofire.Method) = {
            
            switch self{
                
            case .SearchRoutes(let latOrigin, let lngOrigin, let latDest, let lngDest, let accessToken):
                
                var params:[String:AnyObject] = [:]
                params["lat0"] = latOrigin
                params["lng0"] = lngOrigin
                params["lat1"] = latDest
                params["lng1"] = lngDest
                params["tk"]   = accessToken
                
                return ("NexusApi.php", params, .URL, .GET)
                
            case .SearchSingleRoad(let idLine, let direction, let beginStopLine, let endStopLine, let accessToken):
                
                var params:[String:AnyObject] = [:]
                params["idline"]    = idLine
                params["direction"] = direction
                params["stop1"]     = beginStopLine
                params["stop2"]     = endStopLine
                params["tk"]        = accessToken
                
                return ("SingleRoadApi.php", params, .URL, .GET)
                
            case .SearchCombinedRoad(let idFirstLine, let idSecondLine, let firstDirection, let secondDirection, let beginStopFirstLine, let endStopFirstLine, let beginStopSecondLine, let endStopSecondLine, let accessToken):
                
                var params:[String:AnyObject] = [:]
                params["idline1"] = idFirstLine
                params["idline2"] = idSecondLine
                params["direction1"] = firstDirection
                params["direction2"] = secondDirection
                params["L1stop1"] = beginStopFirstLine
                params["L1stop2"] = endStopFirstLine
                params["L2stop1"] = beginStopSecondLine
                params["L2stop2"] = endStopSecondLine
                params["tk"] = accessToken
                
                return ("CombinedRoadApi.php",params,.URL,.GET)
            
            case .RechargeCardPoints:
                return ("RechargeCardPointApi.php",[:],.URL,.GET)
            }
            
        }()
        
        let URL = NSURL(string: MyBusRouter.MYBUS_BASE_URL)
        let URLRequest = NSMutableURLRequest(URL: URL!.URLByAppendingPathComponent(path))
        
        URLRequest.HTTPMethod = method.rawValue
        
        return encoding.encode(URLRequest, parameters: parameters).0
        
    }
}



class BaseNetworkService{
    
    
    class func performRequest(urlString: String, completionHandler: (JSON?, NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
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
    
    class func performRequest(request:NSURLRequest, completionHandler:(JSON?, NSError?)->Void){
        
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
}
