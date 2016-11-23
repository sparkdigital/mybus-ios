//
//  RouteTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/9/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import SwiftyJSON

class RouteTest: XCTestCase
{
    var firstRoute:Route = Route()
    var secondRoute:Route = Route()
    
    override func setUp()
    {
        super.setUp()
        
        // First Route
        let firstRouteFilePath = NSBundle(forClass: RouteTest.self).pathForResource("Route_1", ofType: "json")
        
        let firstRouteJSONData = try! NSData(contentsOfFile: firstRouteFilePath!, options:.DataReadingMappedIfSafe)
        
        let firstRouteJSON = try! NSJSONSerialization.JSONObjectWithData(firstRouteJSONData, options: .MutableContainers)
        
        let firstRouteDictionary = JSON(firstRouteJSON)
        
        firstRoute = Route.parse(firstRouteDictionary.arrayValue)
        
        // Second Route
        let secondRouteFilePath = NSBundle(forClass: RouteTest.self).pathForResource("Route_2", ofType: "json")
        
        let secondRouteJSONData = try! NSData(contentsOfFile: secondRouteFilePath!, options:.DataReadingMappedIfSafe)
        
        let secondRouteJSON = try! NSJSONSerialization.JSONObjectWithData(secondRouteJSONData, options: .MutableContainers)
        
        let secondRouteDictionary = JSON(secondRouteJSON)
        
        secondRoute = Route.parse(secondRouteDictionary.arrayValue)
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testResultExistence()
    {
        XCTAssertNotNil(firstRoute)
        XCTAssertNotNil(secondRoute)
    }
    
    func testResultForFirstRouteContents()
    {
        // First Route
        for case let item:RoutePoint in firstRoute.pointList
        {
            XCTAssertNotNil(item.stopId)
            XCTAssertNotNil(item.latitude)
            XCTAssertNotNil(item.longitude)
            XCTAssertNotNil(item.address)
            XCTAssertNotNil(item.isWaypoint)
            XCTAssertNotNil(item.name)
        }
    }
    
    func testResultForSecondRouteContents()
    {
        // Second Route
        for case let item:RoutePoint in secondRoute.pointList
        {
            XCTAssertNotNil(item.stopId)
            XCTAssertNotNil(item.latitude)
            XCTAssertNotNil(item.longitude)
            XCTAssertNotNil(item.address)
            XCTAssertNotNil(item.isWaypoint)
            XCTAssertNotNil(item.name)
        }
    }
}
