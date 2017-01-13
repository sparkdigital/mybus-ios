//
//  BusSearchResultSingleTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/21/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import MyBus

class BusSearchResultSingleTest: XCTestCase
{
    var firstBusRouteResultSingle: [BusRouteResult] = []
    var secondBusRouteResultSingle: [BusRouteResult] = []
    
    var firstSingleOriginRoutePoint:RoutePoint = RoutePoint()
    var firstSingleDestinationRoutePoint:RoutePoint = RoutePoint()
    var secondSingleOriginRoutePoint:RoutePoint = RoutePoint()
    var secondSingleDestinationRoutePoint:RoutePoint = RoutePoint()

    var firstBusSearchResultSingle: BusSearchResult = BusSearchResult()!
    var secondBusSearchResultSingle: BusSearchResult = BusSearchResult()!
    
    override func setUp()
    {
        super.setUp()
        
        let firstSingleRouteFilePath = Bundle(for: BusSearchResultSingleTest.self).path(forResource: "BusRouteResultSingle_1", ofType: "json")
        let secondSingleRouteFilePath = Bundle(for: BusSearchResultSingleTest.self).path(forResource: "BusRouteResultSingle_2", ofType: "json")

        let firstSingleOriginRoutePointFilePath = Bundle(for: BusSearchResultSingleTest.self).path(forResource: "RoutePointSingle_1_1", ofType: "json")
        let firstSingleDestinationRoutePointFilePath = Bundle(for: BusSearchResultSingleTest.self).path(forResource: "RoutePointSingle_1_2", ofType: "json")
        let secondSingleOriginRoutePointFilePath = Bundle(for: BusSearchResultSingleTest.self).path(forResource: "RoutePointSingle_2_1", ofType: "json")
        let secondSingleDestinationRoutePointFilePath = Bundle(for: BusSearchResultSingleTest.self).path(forResource: "RoutePointSingle_2_2", ofType: "json")
        
        // Single Routes
        let firstSingleRouteJSONData = try! Data(contentsOf: URL(fileURLWithPath: firstSingleRouteFilePath!), options:.mappedIfSafe)
        let secondSingleRouteJSONData = try! Data(contentsOf: URL(fileURLWithPath: secondSingleRouteFilePath!), options:.mappedIfSafe)
        
        let firstSingleRouteJSON = try! JSONSerialization.jsonObject(with: firstSingleRouteJSONData, options: .mutableContainers)
        let secondSingleRouteJSON = try! JSONSerialization.jsonObject(with: secondSingleRouteJSONData, options: .mutableContainers)
        
        var firstSingleRouteDictionary = JSON(firstSingleRouteJSON)
        var secondSingleRouteDictionary = JSON(secondSingleRouteJSON)
        
        let firstSingleRouteType = firstSingleRouteDictionary["Type"].intValue
        let firstSingleRouteResults = firstSingleRouteDictionary["Results"]
        
        let secondSingleRouteType = secondSingleRouteDictionary["Type"].intValue
        let secondSingleRouteResults = secondSingleRouteDictionary["Results"]
        
        // Single Routes' Points
        let firstSingleOriginRoutePointJSONData = try! Data(contentsOf: URL(fileURLWithPath: firstSingleOriginRoutePointFilePath!), options:.mappedIfSafe)
        let firstSingleDestinationRoutePointJSONData = try! Data(contentsOf: URL(fileURLWithPath: firstSingleDestinationRoutePointFilePath!), options:.mappedIfSafe)
        let secondSingleOriginRoutePointJSONData = try! Data(contentsOf: URL(fileURLWithPath: secondSingleOriginRoutePointFilePath!), options:.mappedIfSafe)
        let secondSingleDestinatonRoutePointJSONData = try! Data(contentsOf: URL(fileURLWithPath: secondSingleDestinationRoutePointFilePath!), options:.mappedIfSafe)
        
        let firstSingleOriginRoutePointJSON = try! JSONSerialization.jsonObject(with: firstSingleOriginRoutePointJSONData, options: .mutableContainers)
        let firstSingleDestinationRoutePointJSON = try! JSONSerialization.jsonObject(with: firstSingleDestinationRoutePointJSONData, options: .mutableContainers)
        let secondSingleOriginRoutePointJSON = try! JSONSerialization.jsonObject(with: secondSingleOriginRoutePointJSONData, options: .mutableContainers)
        let secondSingleDestinationRoutePointJSON = try! JSONSerialization.jsonObject(with: secondSingleDestinatonRoutePointJSONData, options: .mutableContainers)
        
        let firstSingleOriginRoutePointDictionary = JSON(firstSingleOriginRoutePointJSON)
        let firstSingleDestinationRoutePointDictionary = JSON(firstSingleDestinationRoutePointJSON)
        let secondSingleOriginRouteDictionary = JSON(secondSingleOriginRoutePointJSON)
        let secondSingleDestinationRouteDictionary = JSON(secondSingleDestinationRoutePointJSON)
        
        // For logging purposes
        /*
         print("1st BusRouteResult: \(firstSingleRouteDictionary)")
         print("1st OriginRoutePoint: \(firstSingleOriginRoutePointDictionary)")
         print("1st DestinationRoutePoint: \(firstSingleDestinationRoutePointDictionary)")
         
         print("2nd BusRouteResult: \(secondSingleRouteDictionary)")
         print("2nd OriginRoutePoint: \(secondSingleOriginRouteDictionary)")
         print("2nd DestinationRoutePoint: \(secondSingleDestinationRouteDictionary)")
         */
        
        firstBusRouteResultSingle = BusRouteResult.parseResults(firstSingleRouteResults, type: firstSingleRouteType)
        secondBusRouteResultSingle = BusRouteResult.parseResults(secondSingleRouteResults, type: secondSingleRouteType)
        
        firstSingleOriginRoutePoint = RoutePoint.parse(firstSingleOriginRoutePointDictionary)
        firstSingleDestinationRoutePoint = RoutePoint.parse(firstSingleDestinationRoutePointDictionary)
        secondSingleOriginRoutePoint = RoutePoint.parse(secondSingleOriginRouteDictionary)
        secondSingleDestinationRoutePoint = RoutePoint.parse(secondSingleDestinationRouteDictionary)

        firstBusSearchResultSingle = BusSearchResult(origin: firstSingleOriginRoutePoint, destination: firstSingleDestinationRoutePoint, busRoutes: firstBusRouteResultSingle)
        secondBusSearchResultSingle = BusSearchResult(origin: secondSingleOriginRoutePoint, destination: secondSingleDestinationRoutePoint, busRoutes: secondBusRouteResultSingle)
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testResultExistence()
    {
        XCTAssertNotNil(firstBusSearchResultSingle)
        XCTAssertNotNil(secondBusSearchResultSingle)
    }
    
    func testResultUniqueness()
    {
        XCTAssertNotEqual(firstBusSearchResultSingle.origin, firstBusSearchResultSingle.destination)
        XCTAssertNotEqual(secondBusSearchResultSingle.origin, secondBusSearchResultSingle.destination)
    }
    
    func testResultContents()
    {
        XCTAssert(firstBusSearchResultSingle.hasRouteOptions)
        XCTAssert(secondBusSearchResultSingle.hasRouteOptions)
        
        print("\nFirst BusSearchResult Single:\n")
        for case let item:BusRouteResult in firstBusSearchResultSingle.busRouteOptions
        {
            XCTAssertNotNil(item)
            XCTAssert(item.busRoutes.count > 0)
            XCTAssertEqual(item.busRoutes.count > 0, firstBusSearchResultSingle.hasRouteOptions)
            XCTAssertNotNil(item.busRouteType)
            XCTAssertEqual(item.busRouteType, MyBusRouteResultType.Single)
            
            let busSearchDescription = "BusSearchResult with Type:\(item.busRouteType) and CombinationDistance:\(item.combinationDistance)\n"
            
            print(busSearchDescription)
        }
        
        print("\nSecond BusSearchResult Single:\n")
        for case let item:BusRouteResult in secondBusSearchResultSingle.busRouteOptions
        {
            XCTAssertNotNil(item)
            XCTAssert(item.busRoutes.count > 0)
            XCTAssertEqual(item.busRoutes.count > 0, secondBusSearchResultSingle.hasRouteOptions)
            XCTAssertNotNil(item.busRouteType)
            XCTAssertEqual(item.busRouteType, MyBusRouteResultType.Single)
            
            let busSearchDescription = "BusSearchResult with Type:\(item.busRouteType) and CombinationDistance:\(item.combinationDistance)\n"
            
            print(busSearchDescription)
        }
    }
}
