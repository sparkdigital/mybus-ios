//
//  BusRouteResultTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/10/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import MYBUS

class BusRouteResultSingleTest: XCTestCase
{
    var firstResultSingle: [BusRouteResult] = []
    var secondResultSingle: [BusRouteResult] = []
    
    override func setUp()
    {
        super.setUp()
    
        let firstFilePath = Bundle(for: BusRouteResultSingleTest.self).path(forResource: "BusRouteResultSingle_1", ofType: "json")
        let secondFilePath = Bundle(for: BusRouteResultSingleTest.self).path(forResource: "BusRouteResultSingle_2", ofType: "json")
        
        let firstJSONData = try! Data(contentsOf: URL(fileURLWithPath: firstFilePath!), options:.mappedIfSafe)
        let secondJSONData = try! Data(contentsOf: URL(fileURLWithPath: secondFilePath!), options:.mappedIfSafe)
        
        let firstJSON = try! JSONSerialization.jsonObject(with: firstJSONData, options: .mutableContainers)
        let secondJSON = try! JSONSerialization.jsonObject(with: secondJSONData, options: .mutableContainers)
        
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
            XCTAssertEqual(item.busRouteType, MyBusRouteResultType.single)
            
            let busRouteDescription = "BusRouteResult with Type:\(item.busRouteType) and Routes #:\(item.busRoutes.count)\n"
            
            print(busRouteDescription)
        }
        
        print("\nSecond Result Single:\n")
        for case let item:BusRouteResult in secondResultSingle
        {
            XCTAssertNotNil(item)
            XCTAssert(item.busRoutes.count > 0)
            XCTAssertNotNil(item.busRouteType)
            XCTAssertEqual(item.busRouteType, MyBusRouteResultType.single)
            
            let busRouteDescription = "BusRouteResult with Type:\(item.busRouteType) and Routes #:\(item.busRoutes.count)\n"
            
            print(busRouteDescription)
        }
    } 
}
