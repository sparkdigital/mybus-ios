//
//  RoadSearchTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/10/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import MYBUS

class RoadSearchTest: XCTestCase
{
    var firstRouteSingle: [BusRouteResult] = []
    var firstRouteCombined: [BusRouteResult] = []
    var singleRoadSearch:RoadSearch = RoadSearch()!
    var combinedRoadSearch:RoadSearch = RoadSearch()!
    
    override func setUp()
    {
        super.setUp()
        
        // Single Bus Route
        let singleRouteFilePath = Bundle(for: RoadSearchTest.self).path(forResource: "BusRouteResultSingle_1", ofType: "json")
        
        let singleRouteJSONData = try! Data(contentsOf: URL(fileURLWithPath: singleRouteFilePath!), options:.mappedIfSafe)
        
        let singleRouteJSON = try! JSONSerialization.jsonObject(with: singleRouteJSONData, options: .mutableContainers)
        
        var singleRouteDictionary = JSON(singleRouteJSON)
        
        let singleType = singleRouteDictionary["Type"].intValue
        let singleResults = singleRouteDictionary["Results"]
        
        // Combined Bus Route
        let combinedRouteFilePath = Bundle(for: RoadSearchTest.self).path(forResource: "BusRouteResultCombined_1", ofType: "json")
        
        let combinedRouteJSONData = try! Data(contentsOf: URL(fileURLWithPath: combinedRouteFilePath!), options:.mappedIfSafe)
        
        let combinedRouteJSON = try! JSONSerialization.jsonObject(with: combinedRouteJSONData, options: .mutableContainers)
        
        var combinedRouteDictionary = JSON(combinedRouteJSON)
        
        let combinedType = combinedRouteDictionary["Type"].intValue
        let combinedResults = combinedRouteDictionary["Results"]
        
        // For logging purposes
        //print("1st Route (Single): \(singleRouteDictionary)")
        //print("2nd Route (Combined): \(combinedRouteDictionary)")
        
        firstRouteSingle = BusRouteResult.parseResults(singleResults, type: singleType)
        firstRouteCombined = BusRouteResult.parseResults(combinedResults, type: combinedType)
        
        let firstSingleBusRoute = firstRouteSingle.first?.busRoutes.first
        
        singleRoadSearch = RoadSearch(singleRoad: firstSingleBusRoute!.idBusLine!, firstDirection: firstSingleBusRoute!.busLineDirection, beginStopFirstLine: firstSingleBusRoute!.startBusStopNumber, endStopFirstLine: firstSingleBusRoute!.destinationBusStopNumber)
        
        let firstCombinedBusRoute = firstRouteCombined.first?.busRoutes.first
        let secondCombinedBusRoute = firstRouteCombined.first?.busRoutes.last
        
        combinedRoadSearch = RoadSearch(combinedRoad: firstCombinedBusRoute!.idBusLine!, firstDirection: firstCombinedBusRoute!.busLineDirection, beginStopFirstLine: firstCombinedBusRoute!.idBusLine!, endStopFirstLine: firstCombinedBusRoute!.destinationBusStopNumber, idSecondLine: secondCombinedBusRoute!.idBusLine!, secondDirection: secondCombinedBusRoute!.busLineDirection, beginStopSecondLine: secondCombinedBusRoute!.startBusStopNumber, endStopSecondLine: secondCombinedBusRoute!.destinationBusStopNumber)
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testResultExistence()
    {
        XCTAssertNotNil(firstRouteSingle)
        XCTAssertNotNil(firstRouteCombined)
        
        XCTAssertNotNil(singleRoadSearch)
        XCTAssertNotNil(combinedRoadSearch)
    }
    
    func testResultUniqueness()
    {
        XCTAssertNotEqual(singleRoadSearch.idFirstLine, singleRoadSearch.idSecondLine)
        XCTAssertNotEqual(combinedRoadSearch.idFirstLine, combinedRoadSearch.idSecondLine)
        
        XCTAssertNotEqual(singleRoadSearch.idFirstLine, combinedRoadSearch.idFirstLine)
        XCTAssertNotEqual(singleRoadSearch.idSecondLine, combinedRoadSearch.idSecondLine)
    }
    
    func testResultContents()
    {
        XCTAssertNotNil(singleRoadSearch.idFirstLine)
        XCTAssertNotNil(singleRoadSearch.firstDirection)
        XCTAssertNotNil(singleRoadSearch.beginStopFirstLine)
        XCTAssertNotNil(singleRoadSearch.endStopFirstLine)
        XCTAssertEqual(singleRoadSearch.idSecondLine, 0)
        XCTAssertEqual(singleRoadSearch.secondDirection, 0)
        XCTAssertEqual(singleRoadSearch.beginStopSecondLine, 0)
        XCTAssertEqual(singleRoadSearch.endStopSecondLine, 0)
        
        XCTAssertNotNil(combinedRoadSearch.idFirstLine)
        XCTAssertNotNil(combinedRoadSearch.idSecondLine)
        XCTAssertNotNil(combinedRoadSearch.firstDirection)
        XCTAssertNotNil(combinedRoadSearch.secondDirection)
        XCTAssertNotNil(combinedRoadSearch.beginStopFirstLine)
        XCTAssertNotNil(combinedRoadSearch.endStopFirstLine)
        XCTAssertNotNil(combinedRoadSearch.beginStopSecondLine)
        XCTAssertNotNil(combinedRoadSearch.endStopSecondLine)
    }    
}
