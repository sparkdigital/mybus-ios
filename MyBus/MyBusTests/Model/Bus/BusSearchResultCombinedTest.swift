//
//  BusSearchResultCombinedTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/10/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import MyBus

class BusSearchResultCombinedTest: XCTestCase
{
    var firstBusRouteResultCombined: [BusRouteResult] = []
    var secondBusRouteResultCombined: [BusRouteResult] = []
    
    var firstCombinedOriginRoutePoint:RoutePoint = RoutePoint()
    var firstCombinedDestinationRoutePoint:RoutePoint = RoutePoint()
    var secondCombinedOriginRoutePoint:RoutePoint = RoutePoint()
    var secondCombinedDestinationRoutePoint:RoutePoint = RoutePoint()
    
    var firstBusSearchResultCombined: BusSearchResult = BusSearchResult()!
    var secondBusSearchResultCombined: BusSearchResult = BusSearchResult()!
    
    override func setUp()
    {
        super.setUp()

        let firstCombinedRouteFilePath = NSBundle(forClass: BusSearchResultCombinedTest.self).pathForResource("BusRouteResultCombined_1", ofType: "json")
        let secondCombinedRouteFilePath = NSBundle(forClass: BusSearchResultCombinedTest.self).pathForResource("BusRouteResultCombined_2", ofType: "json")
        
        let firstCombinedOriginRoutePointFilePath = NSBundle(forClass: BusSearchResultCombinedTest.self).pathForResource("RoutePointCombined_1_1", ofType: "json")
        let firstCombinedDestinationRoutePointFilePath = NSBundle(forClass: BusSearchResultCombinedTest.self).pathForResource("RoutePointCombined_1_2", ofType: "json")
        let secondCombinedOriginRoutePointFilePath = NSBundle(forClass: BusSearchResultCombinedTest.self).pathForResource("RoutePointCombined_2_1", ofType: "json")
        let secondCombinedDestinationRoutePointFilePath = NSBundle(forClass: BusSearchResultCombinedTest.self).pathForResource("RoutePointCombined_2_2", ofType: "json")
        
        // Combined Routes
        let firstCombinedRouteJSONData = try! NSData(contentsOfFile: firstCombinedRouteFilePath!, options:.DataReadingMappedIfSafe)
        let secondCombinedRouteJSONData = try! NSData(contentsOfFile: secondCombinedRouteFilePath!, options:.DataReadingMappedIfSafe)
        
        let firstCombinedRouteJSON = try! NSJSONSerialization.JSONObjectWithData(firstCombinedRouteJSONData, options: .MutableContainers)
        let secondCombinedRouteJSON = try! NSJSONSerialization.JSONObjectWithData(secondCombinedRouteJSONData, options: .MutableContainers)
        
        var firstCombinedRouteDictionary = JSON(firstCombinedRouteJSON)
        var secondCombinedRouteDictionary = JSON(secondCombinedRouteJSON)
        
        let firstCombinedRouteType = firstCombinedRouteDictionary["Type"].intValue
        let firstCombinedRouteResults = firstCombinedRouteDictionary["Results"]
        
        let secondCombinedRouteType = secondCombinedRouteDictionary["Type"].intValue
        let secondCombinedRouteResults = secondCombinedRouteDictionary["Results"]
        
        // Combined Routes' Points
        let firstCombinedOriginRoutePointJSONData = try! NSData(contentsOfFile: firstCombinedOriginRoutePointFilePath!, options:.DataReadingMappedIfSafe)
        let firstCombinedDestinationRoutePointJSONData = try! NSData(contentsOfFile: firstCombinedDestinationRoutePointFilePath!, options:.DataReadingMappedIfSafe)
        let secondCombinedOriginRoutePointJSONData = try! NSData(contentsOfFile: secondCombinedOriginRoutePointFilePath!, options:.DataReadingMappedIfSafe)
        let secondCombinedDestinationRoutePointJSONData = try! NSData(contentsOfFile: secondCombinedDestinationRoutePointFilePath!, options:.DataReadingMappedIfSafe)
        
        let firstCombinedOriginRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(firstCombinedOriginRoutePointJSONData, options: .MutableContainers)
        let firstCombinedDestinationRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(firstCombinedDestinationRoutePointJSONData, options: .MutableContainers)
        let secondCombinedOriginRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(secondCombinedOriginRoutePointJSONData, options: .MutableContainers)
        let secondCombinedDestinationRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(secondCombinedDestinationRoutePointJSONData, options: .MutableContainers)
        
        let firstCombinedOriginRoutePointDictionary = JSON(firstCombinedOriginRoutePointJSON)
        let firstCombinedDestinationRoutePointDictionary = JSON(firstCombinedDestinationRoutePointJSON)
        let secondCombinedOriginRoutePointDictionary = JSON(secondCombinedOriginRoutePointJSON)
        let secondCombinedDestinationRoutePointDictionary = JSON(secondCombinedDestinationRoutePointJSON)
        
        // For logging purposes
        /*
        print("1st BusRouteResult: \(firstCombinedRouteDictionary)")
        print("1st OriginRoutePoint: \(firstCombinedOriginRoutePointDictionary)")
        print("1st DestinationRoutePoint: \(firstCombinedDestinationRoutePointDictionary)")
         
        print("2nd BusRouteResult: \(secondCombinedRouteDictionary)")
        print("2nd OriginRoutePoint: \(secondCombinedOriginRoutePointDictionary)")
        print("2nd DestinationRoutePoint: \(secondCombinedDestinationRoutePointDictionary)")
        */

        firstBusRouteResultCombined = BusRouteResult.parseResults(firstCombinedRouteResults, type: firstCombinedRouteType)
        secondBusRouteResultCombined = BusRouteResult.parseResults(secondCombinedRouteResults, type: secondCombinedRouteType)

        firstCombinedOriginRoutePoint = RoutePoint.parse(firstCombinedOriginRoutePointDictionary)
        firstCombinedDestinationRoutePoint = RoutePoint.parse(firstCombinedDestinationRoutePointDictionary)
        secondCombinedOriginRoutePoint = RoutePoint.parse(secondCombinedOriginRoutePointDictionary)
        secondCombinedDestinationRoutePoint = RoutePoint.parse(secondCombinedDestinationRoutePointDictionary)
        
        firstBusSearchResultCombined = BusSearchResult(origin: firstCombinedOriginRoutePoint, destination: firstCombinedDestinationRoutePoint, busRoutes: firstBusRouteResultCombined)
        secondBusSearchResultCombined = BusSearchResult(origin: secondCombinedOriginRoutePoint, destination: secondCombinedDestinationRoutePoint, busRoutes: secondBusRouteResultCombined)
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testResultExistence()
    {
        XCTAssertNotNil(firstBusSearchResultCombined)
        XCTAssertNotNil(secondBusSearchResultCombined)
    }
    
    func testResultUniqueness()
    {
        XCTAssertNotEqual(firstBusSearchResultCombined.origin, firstBusSearchResultCombined.destination)
        XCTAssertNotEqual(secondBusSearchResultCombined.origin, secondBusSearchResultCombined.destination)
    }
    
    func testResultContents()
    {
        XCTAssert(firstBusSearchResultCombined.hasRouteOptions)
        XCTAssert(secondBusSearchResultCombined.hasRouteOptions)
        
        print("\nFirst BusSearchResult Combined:\n")
        for case let item:BusRouteResult in firstBusSearchResultCombined.busRouteOptions
        {
            XCTAssertNotNil(item)
            XCTAssert(item.busRoutes.count > 0)
            XCTAssertNotNil(item.busRouteType)
            XCTAssertEqual(item.busRouteType, MyBusRouteResultType.Combined)
            
            let busSearchDescription = "BusSearchResult with Type:\(item.busRouteType) and CombinationDistance:\(item.combinationDistance)\n"
            
            print(busSearchDescription)
        }
        
        print("\nSecond BusSearchResult Combined:\n")
        for case let item:BusRouteResult in secondBusSearchResultCombined.busRouteOptions
        {
            XCTAssertNotNil(item)
            XCTAssert(item.busRoutes.count > 0)
            XCTAssertNotNil(item.busRouteType)
            XCTAssertEqual(item.busRouteType, MyBusRouteResultType.Combined)
            
            let busSearchDescription = "BusSearchResult with Type:\(item.busRouteType) and CombinationDistance:\(item.combinationDistance)\n"
            
            print(busSearchDescription)
        }
    }
}
