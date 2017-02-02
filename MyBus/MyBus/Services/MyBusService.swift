//
//  MyBusService.swift
//  MyBus
//
//  Created by Lisandro Falconi on 5/26/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum MyBusRouteResultType {
    case combined, single
}

protocol MyBusServiceDelegate {
    func searchRoutes(_ latitudeOrigin: Double, longitudeOrigin: Double, latitudeDestination: Double, longitudeDestination: Double, completionHandler: @escaping ([BusRouteResult]?, Error?) -> ())
    func searchRoads(_ roadType: MyBusRouteResultType, roadSearch: RoadSearch, completionHandler: @escaping (RoadResult?, Error?) -> ())
    func getCompleteRoads(_ idLine: Int, direction: Int, completionHandler: @escaping (CompleteBusRoute?, Error?) -> ())
}

open class MyBusService: NSObject, MyBusServiceDelegate {

    internal func searchRoutes(_ latitudeOrigin: Double, longitudeOrigin: Double, latitudeDestination: Double, longitudeDestination: Double, completionHandler: @escaping ([BusRouteResult]?, Error?) -> ()) {

        do {
            let request = try MyBusRouter.searchRoutes(latOrigin: latitudeOrigin, lngOrigin: longitudeOrigin, latDest: latitudeDestination, lngDest: longitudeDestination, accessToken: MyBusRouter.MYBUS_ACCESS_TOKEN).asURLRequest()
            
            BaseNetworkService.performRequest(request) { json, error in
                guard let response = json else {
                    return completionHandler(nil, error)
                }
                
                let type = response["Type"].intValue
                let results = response["Results"]
                let busResults: [BusRouteResult]
                
                busResults = BusRouteResult.parseResults(results, type: type)
                completionHandler(busResults, nil)
            }
        } catch {
            NSLog("Failed building search routes URL request")
        }
    }

    internal func searchRoads(_ roadType: MyBusRouteResultType, roadSearch: RoadSearch, completionHandler: @escaping (RoadResult?, Error?) -> ()) {

        let idFirstLine = roadSearch.idFirstLine
        let idSecondLine = roadSearch.idSecondLine

        let firstDirection = roadSearch.firstDirection
        let secondDirection = roadSearch.secondDirection

        let beginStopFirstLine = roadSearch.beginStopFirstLine
        let endStopFirstLine = roadSearch.endStopFirstLine

        let beginStopSecondLine = roadSearch.beginStopSecondLine
        let endStopSecondLine = roadSearch.endStopSecondLine



        var request: URLRequest

        switch roadType {
        case .single:
            do {
                request = try MyBusRouter.searchSingleRoad(idLine: idFirstLine, direction: firstDirection, beginStopLine: beginStopFirstLine, endStopLine: endStopFirstLine, accessToken: MyBusRouter.MYBUS_ACCESS_TOKEN).asURLRequest()
                BaseNetworkService.performRequest(request) { response, error in
                    if let json = response {
                        completionHandler(RoadResult.parse(json), nil)
                    } else {
                        LoggingManager.sharedInstance.logError("Road Result Search", error: error)
                        completionHandler(nil, error)
                    }
                }
            } catch {
                NSLog("Failed building search SINGLE routes URL request")
            }
        case .combined:
            do {
                request = try MyBusRouter.searchCombinedRoad(idFirstLine: idFirstLine, idSecondLine: idSecondLine, firstDirection: firstDirection, secondDirection: secondDirection, beginStopFirstLine: beginStopFirstLine, endStopFirstLine: endStopFirstLine, beginStopSecondLine: beginStopSecondLine, endStopSecondLine: endStopSecondLine, accessToken: MyBusRouter.MYBUS_ACCESS_TOKEN).asURLRequest()
                BaseNetworkService.performRequest(request) { response, error in
                    if let json = response {
                        completionHandler(RoadResult.parse(json), nil)
                    } else {
                        LoggingManager.sharedInstance.logError("Road Result Search", error: error)
                        completionHandler(nil, error)
                    }
                }
            } catch {
                NSLog("Failed building search COMBINED routes URL request")
            }
        }

        
    }

    internal func getCompleteRoads(_ idLine: Int, direction: Int, completionHandler: @escaping (CompleteBusRoute?, Error?)->()) -> Void {
        do {
            let request = try MyBusRouter.completeRoads(idLine: idLine, direction: direction, accessToken: MyBusRouter.MYBUS_ACCESS_TOKEN).asURLRequest()
            BaseNetworkService.performRequest(request) { response, error in
                if let json = response {
                    
                    print("Bus Line: \(idLine) \nCompleteRoute:\n  \(json)")
                    
                    completionHandler(CompleteBusRoute().parseOneWayBusRoute(json, busLineName: ""), nil)
                } else {
                    LoggingManager.sharedInstance.logError("Complete Bus Route Search", error: error)
                    completionHandler(nil, error)
                }
            }
        } catch {
            NSLog("Failed building search complete roads URL request")
        }
    }

    internal func getRechargeCardPoints(_ latitude: Double, longitude: Double, completionHandler: @escaping ([RechargePoint]?, Error?)-> ()) -> Void {
        
        do {
            let request = try MyBusRouter.rechargeCardPoints(latitude: latitude, longitude: longitude, accessToken: MyBusRouter.MYBUS_ACCESS_TOKEN).asURLRequest()
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
                        LoggingManager.sharedInstance.logError("Recharge Points, No Points", error: error)
                        completionHandler(nil, error)
                    } else {
                        completionHandler(points, error)
                    }
                } else {
                    LoggingManager.sharedInstance.logError("Recharge Points", error: error)
                    completionHandler(nil, error)
                }
            }
        } catch {
            NSLog("Failed building recharge points URL request")
        }
    }
}
