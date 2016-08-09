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
    
    
    var URLRequest: NSMutableURLRequest {
        
        return NSMutableURLRequest()
        
    }
}

enum GISRouter:URLRequestConvertible{
    
    
    var URLRequest: NSMutableURLRequest {
        
        return NSMutableURLRequest()
        
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
                
            default:
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
    
    
    func performRequest(urlString: String, completionHandler: (JSON?, NSError?) -> Void) {
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
    
    func performRequest(request:NSURLRequest, completionHandler:(JSON?, NSError?)->Void){
        
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
