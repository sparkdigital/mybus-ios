//
//  BusCombinedRouteResultTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/16/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import SwiftyJSON

class BusRouteResultCombinedTest: XCTestCase
{
    var firstResultCombined: [BusRouteResult] = []
    var secondResultCombined: [BusRouteResult] = []
    
    override func setUp()
    {
        super.setUp()
        
        let firstFilePath = NSBundle(forClass: BusRouteResultCombinedTest.self).pathForResource("BusRouteResultCombined_1", ofType: "json")
        let secondFilePath = NSBundle(forClass: BusRouteResultCombinedTest.self).pathForResource("BusRouteResultCombined_2", ofType: "json")
        
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
        
        firstResultCombined = BusRouteResult.parseResults(firstResults, type: firstType)
        secondResultCombined = BusRouteResult.parseResults(secondResults, type: secondType)
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testResultExistence()
    {
        XCTAssertNotNil(firstResultCombined)
        XCTAssertNotNil(secondResultCombined)
    }
    
    func testResultUniqueness()
    {
        XCTAssertNotEqual(firstResultCombined, secondResultCombined)
    }
    
    func testResultContents()
    {
        XCTAssert(firstResultCombined.count > 0)
        XCTAssert(secondResultCombined.count > 0)
        
        print("\nFirst Result Combined:\n")
        for case let item:BusRouteResult in firstResultCombined
        {
            XCTAssertNotNil(item)
            XCTAssert(item.busRoutes.count > 0)
            XCTAssertNotNil(item.busRouteType)
            XCTAssertEqual(item.busRouteType, MyBusRouteResultType.Combined)
            XCTAssertGreaterThanOrEqual(item.combinationDistance, 0.0)
            
            let busRouteDescription = "BusRouteResult with Type:\(item.busRouteType) and CombinationDistance:\(item.combinationDistance)\n"
            
            print(busRouteDescription)
        }
        
        print("\nSecond Result Combined:\n")
        for case let item:BusRouteResult in secondResultCombined
        {
            XCTAssertNotNil(item)
            XCTAssert(item.busRoutes.count > 0)
            XCTAssertNotNil(item.busRouteType)
            XCTAssertEqual(item.busRouteType, MyBusRouteResultType.Combined)
            XCTAssertGreaterThanOrEqual(item.combinationDistance, 0.0)
            
            let busRouteDescription = "BusRouteResult with Type:\(item.busRouteType) and CombinationDistance:\(item.combinationDistance)\n"
            
            print(busRouteDescription)
        }
    }
}
