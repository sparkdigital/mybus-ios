//
//  MyBusService.swift
//  MyBus
//
//  Created by Lisandro Falconi on 5/26/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public enum MyBusRouteResultType {
    case Combined, Single
}

protocol MyBusServiceDelegate {
    func searchRoutes(latitudeOrigin: Double, longitudeOrigin: Double, latitudeDestination: Double, longitudeDestination: Double, completionHandler: ([BusRouteResult]?, NSError?) -> ())
    func searchRoads(roadType: MyBusRouteResultType, roadSearch: RoadSearch, completionHandler: (RoadResult?, NSError?) -> ())
}

private let myBusAccessToken = "94a08da1fecbb6e8b46990538c7b50b2"
private let myBusBaseURL = "http://www.mybus.com.ar/api/v1/"

public class MyBusService: NSObject, MyBusServiceDelegate {

    private let availableBusLinesFromOriginDestinationEndpointURL = "\(myBusBaseURL)NexusApi.php?"

    private let singleResultRoadEndpointURL = "\(myBusBaseURL)SingleRoadApi.php?"

    private let combinedResultRoadEndpointURL = "\(myBusBaseURL)CombinedRoadApi.php?"

    private let rechargeCardPointsEndpointURL = "\(myBusBaseURL)RechargeCardPointApi.php?"

    func searchRoutes(latitudeOrigin: Double, longitudeOrigin: Double, latitudeDestination: Double, longitudeDestination: Double, completionHandler: ([BusRouteResult]?, NSError?) -> ()) {

        let availableBusLinesFromOriginDestinationURLString = "\(availableBusLinesFromOriginDestinationEndpointURL)lat0=\(latitudeOrigin)&lng0=\(longitudeOrigin)&lat1=\(latitudeDestination)&lng1=\(longitudeDestination)&tk=\(myBusAccessToken)"

        let request = NSMutableURLRequest(URL: NSURL(string: availableBusLinesFromOriginDestinationURLString)!)

        request.HTTPMethod = "GET"

        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .Success(let value):
                let json = JSON(value)
                let type = json["Type"].intValue
                let results = json["Results"]
                let busResults: [BusRouteResult]

                busResults = BusRouteResult.parseResults(results, type: type)

                completionHandler(busResults, nil)
            case .Failure(let error):
                completionHandler(nil, error)
            }
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

        switch roadType {
        case .Single:
            let singleResultRoadURLString = "\(singleResultRoadEndpointURL)idline=\(idFirstLine)&direction=\(firstDirection)&stop1=\(beginStopFirstLine)&stop2=\(endStopFirstLine)&tk=\(myBusAccessToken)"

            let request = NSMutableURLRequest(URL: NSURL(string: singleResultRoadURLString)!)
            request.HTTPMethod = "GET"

            Alamofire.request(request).responseJSON { response in
                switch response.result {
                case .Success(let value):
                    let json = JSON(value)
                    let singleRoadResult = RoadResult.parse(json)
                    completionHandler(singleRoadResult, nil)
                case .Failure(let error):
                    completionHandler(nil, error)
                }
            }
        case .Combined:
            let combinedResultRoadURLString = "\(combinedResultRoadEndpointURL)idline1=\(idFirstLine)&idline2=\(idSecondLine)&direction1=\(firstDirection)&direction2=\(secondDirection)&L1stop1=\(beginStopFirstLine)&L1stop2=\(endStopFirstLine)&L2stop1=\(beginStopSecondLine)&L2stop2=\(endStopSecondLine)&tk=\(myBusAccessToken)"
            print(combinedResultRoadURLString)
            let request = NSMutableURLRequest(URL: NSURL(string: combinedResultRoadURLString)!)
            request.HTTPMethod = "GET"

            Alamofire.request(request).responseJSON { response in
                switch response.result {
                case .Success(let value):
                    let json = JSON(value)
                    let combinedRoadResult = RoadResult.parse(json)
                    completionHandler(combinedRoadResult, nil)
                case .Failure(let error):
                    completionHandler(nil, error)
                }
            }
        }
    }

}
