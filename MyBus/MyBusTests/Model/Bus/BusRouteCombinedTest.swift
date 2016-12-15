//
//  BusCombinedRouteTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/16/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import MyBus

class BusRouteCombinedTest: XCTestCase
{
    var firstResultCombinedArray: [BusRouteResult] = []
    var secondResultCombinedArray: [BusRouteResult] = []
    
    override func setUp()
    {
        super.setUp()
        
        let firstFilePath = NSBundle(forClass: BusRouteCombinedTest.self).pathForResource("BusRouteResultCombined_1", ofType: "json")
        let secondFilePath = NSBundle(forClass: BusRouteCombinedTest.self).pathForResource("BusRouteResultCombined_2", ofType: "json")
        
        let firstJSONData = try! NSData(contentsOfFile: firstFilePath!, options:.DataReadingMappedIfSafe)
        let secondJSONData = try! NSData(contentsOfFile: secondFilePath!, options:.DataReadingMappedIfSafe)
        
        let firstJSON = try! NSJSONSerialization.JSONObjectWithData(firstJSONData, options: .MutableContainers)
        let secondJSON = try! NSJSONSerialization.JSONObjectWithData(secondJSONData, options: .MutableContainers)
        
        var firstRouteDictionary = JSON(firstJSON)
        var secondRouteDictionary = JSON(secondJSON)
        
        let firstType = firstRouteDictionary["Type"].intValue
        let firstResults = firstRouteDictionary["Results"]
        
        let secondType = secondRouteDictionary["Type"].intValue
        let secondResults = secondRouteDictionary["Results"]
        
        // For logging purposes
        //print("1st BusRouteResult: \(firstRouteDictionary)")
        //print("2nd BusRouteResult: \(secondRouteDictionary)")
        
        firstResultCombinedArray = BusRouteResult.parseResults(firstResults, type: firstType)
        secondResultCombinedArray = BusRouteResult.parseResults(secondResults, type: secondType)
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testResultExistence()
    {
        XCTAssertNotNil(firstResultCombinedArray)
        XCTAssertNotNil(secondResultCombinedArray)
    }
    
    func testResultUniqueness()
    {
        XCTAssertNotEqual(firstResultCombinedArray, secondResultCombinedArray)
    }
    
    func testResultContents()
    {
        XCTAssert(firstResultCombinedArray.count > 0)
        XCTAssert(secondResultCombinedArray.count > 0) 
    }
    
    func testFirstRouteResultCombinedForValidContents()
    {
        print("\nFirst Result Combined:\n")
        for case let item:BusRouteResult in firstResultCombinedArray
        {
            let routes = item.busRoutes
            
            for case let subItem:BusRoute in routes
            {
                XCTAssertNotNil(subItem)
                
                XCTAssertGreaterThanOrEqual(subItem.idBusLine!, 0)
                XCTAssertGreaterThanOrEqual(subItem.busLineDirection, 0)
                XCTAssertGreaterThanOrEqual(subItem.startBusStopNumber, 0)
                XCTAssertGreaterThanOrEqual(subItem.startBusStopStreetNumber, 0)
                XCTAssertGreaterThanOrEqual(subItem.startBusStopDistanceToOrigin, 0.0)
                XCTAssertGreaterThanOrEqual(subItem.destinationBusStopNumber, 0)
                XCTAssertGreaterThanOrEqual(subItem.destinationBusStopStreetNumber, 0)
                XCTAssertGreaterThanOrEqual(subItem.destinationBusStopDistanceToDestination, 0.0)
                
                XCTAssertNotNil(subItem.busLineName)
                XCTAssertNotNil(subItem.busLineColor)
                XCTAssertNotNil(subItem.startBusStopLat)
                XCTAssertNotNil(subItem.startBusStopLng)
                XCTAssertNotNil(subItem.startBusStopStreetName)
                XCTAssertNotNil(subItem.destinationBusStopLat)
                XCTAssertNotNil(subItem.destinationBusStopLng)
                XCTAssertNotNil(subItem.destinationBusStopStreetName)
                
                XCTAssertNotEqual(subItem.startBusStopLat, subItem.destinationBusStopLat)
                XCTAssertNotEqual(subItem.startBusStopLng, subItem.destinationBusStopLng)
                
                let busRouteDescription = "Route: Bus \(subItem.busLineName) from \(subItem.startBusStopStreetName) \(subItem.startBusStopStreetNumber) to \(subItem.destinationBusStopStreetName) \(subItem.destinationBusStopStreetNumber)"
                
                print(busRouteDescription)
            }
        }
    }
    
    func testSecondRouteResultCombinedForValidContents()
    {
        print("\nSecond Result Combined:\n")
        for case let item:BusRouteResult in secondResultCombinedArray
        {
            let routes = item.busRoutes
            
            for case let subItem:BusRoute in routes
            {
                XCTAssertNotNil(subItem)
                
                XCTAssertGreaterThanOrEqual(subItem.idBusLine!, 0)
                XCTAssertGreaterThanOrEqual(subItem.busLineDirection, 0)
                XCTAssertGreaterThanOrEqual(subItem.startBusStopNumber, 0)
                XCTAssertGreaterThanOrEqual(subItem.startBusStopStreetNumber, 0)
                XCTAssertGreaterThanOrEqual(subItem.startBusStopDistanceToOrigin, 0.0)
                XCTAssertGreaterThanOrEqual(subItem.destinationBusStopNumber, 0)
                XCTAssertGreaterThanOrEqual(subItem.destinationBusStopStreetNumber, 0)
                XCTAssertGreaterThanOrEqual(subItem.destinationBusStopDistanceToDestination, 0.0)
                
                XCTAssertNotNil(subItem.busLineName)
                XCTAssertNotNil(subItem.busLineColor)
                XCTAssertNotNil(subItem.startBusStopLat)
                XCTAssertNotNil(subItem.startBusStopLng)
                XCTAssertNotNil(subItem.startBusStopStreetName)
                XCTAssertNotNil(subItem.destinationBusStopLat)
                XCTAssertNotNil(subItem.destinationBusStopLng)
                XCTAssertNotNil(subItem.destinationBusStopStreetName)
                
                XCTAssertNotEqual(subItem.startBusStopLat, subItem.destinationBusStopLat)
                XCTAssertNotEqual(subItem.startBusStopLng, subItem.destinationBusStopLng)
                
                let busRouteDescription = "Route: Bus \(subItem.busLineName) from \(subItem.startBusStopStreetName) \(subItem.startBusStopStreetNumber) to \(subItem.destinationBusStopStreetName) \(subItem.destinationBusStopStreetNumber)\n"
                
                print(busRouteDescription)
            }
        }
    }
}
