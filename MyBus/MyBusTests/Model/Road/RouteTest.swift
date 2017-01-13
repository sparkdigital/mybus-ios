//
//  RouteTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/9/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import MyBus

class RouteTest: XCTestCase
{
    var firstRoute:Route = Route()
    var secondRoute:Route = Route()
    
    override func setUp()
    {
        super.setUp()
        
        // First Route
        let firstRouteFilePath = Bundle(for: RouteTest.self).path(forResource: "Route_1", ofType: "json")
        
        let firstRouteJSONData = try! Data(contentsOf: URL(fileURLWithPath: firstRouteFilePath!), options:.mappedIfSafe)
        
        let firstRouteJSON = try! JSONSerialization.jsonObject(with: firstRouteJSONData, options: .mutableContainers)
        
        let firstRouteDictionary = JSON(firstRouteJSON)
        
        firstRoute = Route.parse(firstRouteDictionary.arrayValue)
        
        // Second Route
        let secondRouteFilePath = Bundle(for: RouteTest.self).path(forResource: "Route_2", ofType: "json")
        
        let secondRouteJSONData = try! Data(contentsOf: URL(fileURLWithPath: secondRouteFilePath!), options:.mappedIfSafe)
        
        let secondRouteJSON = try! JSONSerialization.jsonObject(with: secondRouteJSONData, options: .mutableContainers)
        
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
