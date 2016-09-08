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
            guard json != nil else {
                return completionHandler(nil, error)
            }

            let type = json!["Type"].intValue
            let results = json!["Results"]
            let busResults: [BusRouteResult]

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
                completionHandler(RoadResult.parse(json), nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }

    func getCompleteRoads(idLine: Int, direction: Int, completionHandler: (CompleteBusRoute?, NSError?)->()) -> Void {
        var request: NSURLRequest
        request = MyBusRouter.CompleteRoads(idLine: idLine, direction: direction, accessToken: MyBusRouter.MYBUS_ACCESS_TOKEN).URLRequest

        BaseNetworkService.performRequest(request) { response, error in
            if let json = response {
                completionHandler(CompleteBusRoute(), nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
}
