//
//  BusSearchResultSingleTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/21/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import SwiftyJSON

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
        
        let firstSingleRouteFilePath = NSBundle(forClass: BusSearchResultSingleTest.self).pathForResource("BusRouteResultSingle_1", ofType: "json")
        let secondSingleRouteFilePath = NSBundle(forClass: BusSearchResultSingleTest.self).pathForResource("BusRouteResultSingle_2", ofType: "json")

        let firstSingleOriginRoutePointFilePath = NSBundle(forClass: BusSearchResultSingleTest.self).pathForResource("RoutePointSingle_1_1", ofType: "json")
        let firstSingleDestinationRoutePointFilePath = NSBundle(forClass: BusSearchResultSingleTest.self).pathForResource("RoutePointSingle_1_2", ofType: "json")
        let secondSingleOriginRoutePointFilePath = NSBundle(forClass: BusSearchResultSingleTest.self).pathForResource("RoutePointSingle_2_1", ofType: "json")
        let secondSingleDestinationRoutePointFilePath = NSBundle(forClass: BusSearchResultSingleTest.self).pathForResource("RoutePointSingle_2_2", ofType: "json")
        
        // Single Routes
        let firstSingleRouteJSONData = try! NSData(contentsOfFile: firstSingleRouteFilePath!, options:.DataReadingMappedIfSafe)
        let secondSingleRouteJSONData = try! NSData(contentsOfFile: secondSingleRouteFilePath!, options:.DataReadingMappedIfSafe)
        
        let firstSingleRouteJSON = try! NSJSONSerialization.JSONObjectWithData(firstSingleRouteJSONData, options: .MutableContainers)
        let secondSingleRouteJSON = try! NSJSONSerialization.JSONObjectWithData(secondSingleRouteJSONData, options: .MutableContainers)
        
        var firstSingleRouteDictionary = JSON(firstSingleRouteJSON)
        var secondSingleRouteDictionary = JSON(secondSingleRouteJSON)
        
        let firstSingleRouteType = firstSingleRouteDictionary["Type"].intValue
        let firstSingleRouteResults = firstSingleRouteDictionary["Results"]
        
        let secondSingleRouteType = secondSingleRouteDictionary["Type"].intValue
        let secondSingleRouteResults = secondSingleRouteDictionary["Results"]
        
        // Single Routes' Points
        let firstSingleOriginRoutePointJSONData = try! NSData(contentsOfFile: firstSingleOriginRoutePointFilePath!, options:.DataReadingMappedIfSafe)
        let firstSingleDestinationRoutePointJSONData = try! NSData(contentsOfFile: firstSingleDestinationRoutePointFilePath!, options:.DataReadingMappedIfSafe)
        let secondSingleOriginRoutePointJSONData = try! NSData(contentsOfFile: secondSingleOriginRoutePointFilePath!, options:.DataReadingMappedIfSafe)
        let secondSingleDestinatonRoutePointJSONData = try! NSData(contentsOfFile: secondSingleDestinationRoutePointFilePath!, options:.DataReadingMappedIfSafe)
        
        let firstSingleOriginRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(firstSingleOriginRoutePointJSONData, options: .MutableContainers)
        let firstSingleDestinationRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(firstSingleDestinationRoutePointJSONData, options: .MutableContainers)
        let secondSingleOriginRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(secondSingleOriginRoutePointJSONData, options: .MutableContainers)
        let secondSingleDestinationRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(secondSingleDestinatonRoutePointJSONData, options: .MutableContainers)
        
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
            XCTAssertEqual(firstBusSearchResultSingle.roads(item), firstBusSearchResultSingle.roads(item))
        }
        
        print("\nSecond BusSearchResult Single:\n")
        for case let item:BusRouteResult in secondBusSearchResultSingle.busRouteOptions
        {
            XCTAssertNotNil(item)
            XCTAssert(item.busRoutes.count > 0)
            XCTAssertEqual(item.busRoutes.count > 0, secondBusSearchResultSingle.hasRouteOptions)
            XCTAssertNotNil(item.busRouteType)
            XCTAssertEqual(item.busRouteType, MyBusRouteResultType.Single)
            XCTAssertEqual(secondBusSearchResultSingle.roads(item), secondBusSearchResultSingle.roads(item))
        }
    }
}
