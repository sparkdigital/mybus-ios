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
}

private let myBusAccessToken = Configuration.myBusApiKey()
private let myBusBaseURL = Configuration.myBusApiUrl()

public class MyBusService: NSObject, MyBusServiceDelegate {

    private let availableBusLinesFromOriginDestinationEndpointURL = "\(myBusBaseURL)NexusApi.php?"

    private let singleResultRoadEndpointURL = "\(myBusBaseURL)SingleRoadApi.php?"

    private let combinedResultRoadEndpointURL = "\(myBusBaseURL)CombinedRoadApi.php?"

    private let rechargeCardPointsEndpointURL = "\(myBusBaseURL)RechargeCardPointApi.php?"

    private let baseNetworkService = BaseNetworkService()

    func searchRoutes(latitudeOrigin: Double, longitudeOrigin: Double, latitudeDestination: Double, longitudeDestination: Double, completionHandler: ([BusRouteResult]?, NSError?) -> ()) {

        let availableBusLinesFromOriginDestinationURLString = "\(availableBusLinesFromOriginDestinationEndpointURL)lat0=\(latitudeOrigin)&lng0=\(longitudeOrigin)&lat1=\(latitudeDestination)&lng1=\(longitudeDestination)&tk=\(myBusAccessToken)"

        baseNetworkService.performRequest(availableBusLinesFromOriginDestinationURLString)
        {
            json, error in
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

        let resultRoadURLString: String

        switch roadType {
        case .Single:
            let singleResultRoadURLString = "\(singleResultRoadEndpointURL)idline=\(idFirstLine)&direction=\(firstDirection)&stop1=\(beginStopFirstLine)&stop2=\(endStopFirstLine)&tk=\(myBusAccessToken)"
            resultRoadURLString = singleResultRoadURLString
        case .Combined:
            let combinedResultRoadURLString = "\(combinedResultRoadEndpointURL)idline1=\(idFirstLine)&idline2=\(idSecondLine)&direction1=\(firstDirection)&direction2=\(secondDirection)&L1stop1=\(beginStopFirstLine)&L1stop2=\(endStopFirstLine)&L2stop1=\(beginStopSecondLine)&L2stop2=\(endStopSecondLine)&tk=\(myBusAccessToken)"
            resultRoadURLString = combinedResultRoadURLString
        }

        baseNetworkService.performRequest(resultRoadURLString)
        {
            response, error in
            if let json = response {
                completionHandler(RoadResult.parse(json), nil)
            } else {
                completionHandler(nil, error)
            }
        }


    }

}
