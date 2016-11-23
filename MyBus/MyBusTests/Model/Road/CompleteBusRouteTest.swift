//
//  CompleteBusRouteTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/10/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import SwiftyJSON

class CompleteBusRouteTest: XCTestCase
{
    var going511ACompleteRoute: CompleteBusRoute = CompleteBusRoute()
    var returning511ACompleteRoute: CompleteBusRoute = CompleteBusRoute()
    var complete511ARoute: CompleteBusRoute = CompleteBusRoute()
    
    var going571BCompleteRoute: CompleteBusRoute = CompleteBusRoute()
    var returning571BCompleteRoute: CompleteBusRoute = CompleteBusRoute()
    var complete571BRoute: CompleteBusRoute = CompleteBusRoute()
    
    override func setUp()
    {
        super.setUp()
        
        let going511ACompleteRouteFilePath = NSBundle(forClass: BusSearchResultSingleTest.self).pathForResource("511AGoingCompleteBusRoute", ofType: "json")
        let returning511ACompleteRouteFilePath = NSBundle(forClass: BusSearchResultSingleTest.self).pathForResource("511AReturningCompleteBusRoute", ofType: "json")
        
        let going571BCompleteRouteFilePath = NSBundle(forClass: BusSearchResultSingleTest.self).pathForResource("571BGoingCompleteBusRoute", ofType: "json")
        let returning571BCompleteRouteFilePath = NSBundle(forClass: BusSearchResultSingleTest.self).pathForResource("571BReturningCompleteBusRoute", ofType: "json")

        let going511ACompleteRouteJSONData = try! NSData(contentsOfFile: going511ACompleteRouteFilePath!, options:.DataReadingMappedIfSafe)
        let returning511ACompleteRouteJSONData = try! NSData(contentsOfFile: returning511ACompleteRouteFilePath!, options:.DataReadingMappedIfSafe)
        let going571BCompleteRouteJSONData = try! NSData(contentsOfFile: going571BCompleteRouteFilePath!, options:.DataReadingMappedIfSafe)
        let returning571BCompleteRouteJSONData = try! NSData(contentsOfFile: returning571BCompleteRouteFilePath!, options:.DataReadingMappedIfSafe)
        
        let going511ACompleteRouteJSON = try! NSJSONSerialization.JSONObjectWithData(going511ACompleteRouteJSONData, options: .MutableContainers)
        let returning511ACompleteRouteJSON = try! NSJSONSerialization.JSONObjectWithData(returning511ACompleteRouteJSONData, options: .MutableContainers)
        let going571BCompleteRouteJSON = try! NSJSONSerialization.JSONObjectWithData(going571BCompleteRouteJSONData, options: .MutableContainers)
        let returning571BCompleteRouteJSON = try! NSJSONSerialization.JSONObjectWithData(returning571BCompleteRouteJSONData, options: .MutableContainers)
        
        let going511ACompleteRouteDictionary = JSON(going511ACompleteRouteJSON)
        let returning511ACompleteRouteDictionary = JSON(returning511ACompleteRouteJSON)
        let going571BCompleteRouteDictionary = JSON(going571BCompleteRouteJSON)
        let returning571BCompleteRouteDictionary = JSON(returning571BCompleteRouteJSON)
        
        going511ACompleteRoute = CompleteBusRoute().parseOneWayBusRoute(going511ACompleteRouteDictionary, busLineName: "")
        returning511ACompleteRoute = CompleteBusRoute().parseOneWayBusRoute(returning511ACompleteRouteDictionary, busLineName: "")
        complete511ARoute.busLineName = "511a"
        complete511ARoute.goingPointList = going511ACompleteRoute.goingPointList
        complete511ARoute.returnPointList = returning511ACompleteRoute.goingPointList
        
        going571BCompleteRoute = CompleteBusRoute().parseOneWayBusRoute(going571BCompleteRouteDictionary, busLineName: "")
        returning571BCompleteRoute = CompleteBusRoute().parseOneWayBusRoute(returning571BCompleteRouteDictionary, busLineName: "")
        complete571BRoute.busLineName = "571b"
        complete571BRoute.goingPointList = going571BCompleteRoute.goingPointList
        complete571BRoute.returnPointList = returning571BCompleteRoute.goingPointList
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testResultExistence()
    {
        XCTAssertNotNil(complete511ARoute)
        XCTAssertNotNil(complete571BRoute)
    }
    
    func testResultUniqueness()
    {
        XCTAssertNotEqual(complete511ARoute.busLineName, complete571BRoute.busLineName)
    }
    
    func testResultContents()
    {
        XCTAssert(complete511ARoute.goingPointList.count > 0)
        XCTAssert(complete511ARoute.returnPointList.count > 0)
        
        XCTAssert(complete571BRoute.goingPointList.count > 0)
        XCTAssert(complete571BRoute.returnPointList.count > 0)
    }
    
    func testResultForValidPointList()
    {
        XCTAssertFalse(complete511ARoute.isEqualStartGoingEndReturn())
        XCTAssertFalse(complete511ARoute.isEqualStartReturnEndGoing())
        
        XCTAssertFalse(complete571BRoute.isEqualStartGoingEndReturn())
        XCTAssertFalse(complete571BRoute.isEqualStartReturnEndGoing())
    }
    
    func testResultForBus511ARouteValidContents()
    {
        for case let item:RoutePoint in complete511ARoute.goingPointList
        {
            XCTAssertNotNil(item.stopId)
            XCTAssertNotNil(item.latitude)
            XCTAssertNotNil(item.longitude)
            XCTAssertNotNil(item.address)
            XCTAssertNotNil(item.isWaypoint)
            XCTAssertNotNil(item.name)
        }
        
        for case let item:RoutePoint in complete511ARoute.returnPointList
        {
            XCTAssertNotNil(item.stopId)
            XCTAssertNotNil(item.latitude)
            XCTAssertNotNil(item.longitude)
            XCTAssertNotNil(item.address)
            XCTAssertNotNil(item.isWaypoint)
            XCTAssertNotNil(item.name)
        }
    }
    
    func testResultForBus571BRouteValidContents()
    {
        for case let item:RoutePoint in complete571BRoute.goingPointList
        {
            XCTAssertNotNil(item.stopId)
            XCTAssertNotNil(item.latitude)
            XCTAssertNotNil(item.longitude)
            XCTAssertNotNil(item.address)
            XCTAssertNotNil(item.isWaypoint)
            XCTAssertNotNil(item.name)
        }
        
        for case let item:RoutePoint in complete571BRoute.returnPointList
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
