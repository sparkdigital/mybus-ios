//
//  BusRouteResultTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/10/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import SwiftyJSON

class BusRouteResultSingleTest: XCTestCase
{
    var firstResultSingle: [BusRouteResult] = []
    var secondResultSingle: [BusRouteResult] = []
    
    override func setUp()
    {
        super.setUp()
    
        let firstFilePath = NSBundle(forClass: BusRouteResultSingleTest.self).pathForResource("BusRouteResultSingle_1", ofType: "json")
        let secondFilePath = NSBundle(forClass: BusRouteResultSingleTest.self).pathForResource("BusRouteResultSingle_2", ofType: "json")
        
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
        
        firstResultSingle = BusRouteResult.parseResults(firstResults, type: firstType)
        secondResultSingle = BusRouteResult.parseResults(secondResults, type: secondType)
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testResultExistence()
    {
        XCTAssertNotNil(firstResultSingle)
        XCTAssertNotNil(secondResultSingle)
    }
    
    func testResultUniqueness()
    {
        XCTAssertNotEqual(firstResultSingle, secondResultSingle)
    }
    
    func testResultContents()
    {
        XCTAssert(firstResultSingle.count > 0)
        XCTAssert(secondResultSingle.count > 0)
        
        print("\nFirst Result Single:\n")
        for case let item:BusRouteResult in firstResultSingle
        {
            XCTAssertNotNil(item)
            XCTAssert(item.busRoutes.count > 0)
            XCTAssertNotNil(item.busRouteType)
            XCTAssertEqual(item.busRouteType, MyBusRouteResultType.Single)
        }
        
        print("\nSecond Result Single:\n")
        for case let item:BusRouteResult in secondResultSingle
        {
            XCTAssertNotNil(item)
            XCTAssert(item.busRoutes.count > 0)
            XCTAssertNotNil(item.busRouteType)
            XCTAssertEqual(item.busRouteType, MyBusRouteResultType.Single)
        }
    } 
}
