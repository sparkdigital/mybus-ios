//
//  MyBusService.swift
//  MyBus
//
//  Created by Lisandro Falconi on 5/26/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import SwiftyJSON
import Crashlytics

public enum MyBusRouteResultType {
    case Combined, Single
}

protocol MyBusServiceDelegate {
    func searchRoutes(latitudeOrigin: Double, longitudeOrigin: Double, latitudeDestination: Double, longitudeDestination: Double, completionHandler: ([BusRouteResult]?, NSError?) -> ())
    func searchRoads(roadType: MyBusRouteResultType, roadSearch: RoadSearch, completionHandler: (RoadResult?, NSError?) -> ())
    func getCompleteRoads(idLine: Int, direction: Int, completionHandler: (CompleteBusRoute?, NSError?) -> ())
}

public class MyBusService: NSObject, MyBusServiceDelegate {

    func searchRoutes(latitudeOrigin: Double, longitudeOrigin: Double, latitudeDestination: Double, longitudeDestination: Double, completionHandler: ([BusRouteResult]?, NSError?) -> ()) {


        let request = MyBusRouter.SearchRoutes(latOrigin: latitudeOrigin, lngOrigin: longitudeOrigin, latDest: latitudeDestination, lngDest: longitudeDestination, accessToken: MyBusRouter.MYBUS_ACCESS_TOKEN).URLRequest

        BaseNetworkService.performRequest(request) { json, error in
            guard let response = json else {
                return completionHandler(nil, error)
            }

            let type = response["Type"].intValue
            let results = response["Results"]
            let busResults: [BusRouteResult]
            
            //print("BusRouteResult: \(json)")
            
            busResults = BusRouteResult.parseResults(results, type: type)
            completionHandler(busResults, nil)
        }

    }

    func searchRoads(roadType: MyBusRouteResultType, roadSearch: RoadSearch, completionHandler: (RoadResult?, NSError?) -> ()) {

        let idFirstLine = roadSearch.idFirstLine
        let idSecondLine = roadSearch.idSecondLine

        let firstDirection = roadSearch.firstDirection
        let secondDirection = roadSearch.secondDirection

        let beginStopFirstLine = roadSearch.beginStopFirstLine
        let endStopFirstLine = roadSearch.endStopFirstLine

        let beginStopSecondLine = roadSearch.beginStopSecondLine
        let endStopSecondLine = roadSearch.endStopSecondLine



        var request: NSURLRequest

        if roadType == .Single {
            request = MyBusRouter.SearchSingleRoad(idLine: idFirstLine, direction: firstDirection, beginStopLine: beginStopFirstLine, endStopLine: endStopFirstLine, accessToken: MyBusRouter.MYBUS_ACCESS_TOKEN).URLRequest
        }else{
            request = MyBusRouter.SearchCombinedRoad(idFirstLine: idFirstLine, idSecondLine: idSecondLine, firstDirection: firstDirection, secondDirection: secondDirection, beginStopFirstLine: beginStopFirstLine, endStopFirstLine: endStopFirstLine, beginStopSecondLine: beginStopSecondLine, endStopSecondLine: endStopSecondLine, accessToken: MyBusRouter.MYBUS_ACCESS_TOKEN).URLRequest
        }


        BaseNetworkService.performRequest(request) { response, error in
            if let json = response {
                
                //print("SearchRoads: \(json)")
                
                completionHandler(RoadResult.parse(json), nil)
            } else {
                CLSLogv("searchRoads error %@", getVaList([error!.description]))
                completionHandler(nil, error)
            }
        }
    }

    func getCompleteRoads(idLine: Int, direction: Int, completionHandler: (CompleteBusRoute?, NSError?)->()) -> Void {
        var request: NSURLRequest
        request = MyBusRouter.CompleteRoads(idLine: idLine, direction: direction, accessToken: MyBusRouter.MYBUS_ACCESS_TOKEN).URLRequest

        BaseNetworkService.performRequest(request) { response, error in
            if let json = response {
                
                print("Bus Line: \(idLine) \nCompleteRoute:\n  \(json)")
                
                completionHandler(CompleteBusRoute().parseOneWayBusRoute(json, busLineName: ""), nil)
            } else {
                CLSLogv("searchRoads error %@", getVaList([error!.description]))
                completionHandler(nil, error)
            }
        }
    }

    func getRechargeCardPoints(latitude: Double, longitude: Double, completionHandler: ([RechargePoint]?, NSError?)-> ()) -> Void {
        var request: NSURLRequest
        request = MyBusRouter.RechargeCardPoints(latitude: latitude, longitude: longitude, accessToken: MyBusRouter.MYBUS_ACCESS_TOKEN).URLRequest

        BaseNetworkService.performRequest(request) { response, error in
            if let json = response {
                
                print("RechargePoints: \(json)")
                
                var points: [RechargePoint] = []
                for case let point in json["Results"].arrayValue {
                    if let rechargePoint = RechargePoint(json: point) {
                        points.append(rechargePoint)
                    }
                }
                if points.count == 0 {
                    CLSLogv("searchRoads error %@", getVaList([error!.description]))
                    completionHandler(nil, error)
                } else {
                    completionHandler(points, error)
                }
            } else {
                CLSLogv("searchRoads error %@", getVaList([error!.description]))
                completionHandler(nil, error)
            }
        }
    }
}
