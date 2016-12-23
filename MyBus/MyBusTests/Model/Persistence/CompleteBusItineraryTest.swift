//
//  CompleteBusItineraryTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/10/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import MyBus

class CompleteBusItineraryTest: XCTestCase
{
    var going511ACompleteRoute: CompleteBusRoute = CompleteBusRoute()
    var returning511ACompleteRoute: CompleteBusRoute = CompleteBusRoute()
    var complete511ARoute: CompleteBusRoute = CompleteBusRoute()
    
    var going571BCompleteRoute: CompleteBusRoute = CompleteBusRoute()
    var returning571BCompleteRoute: CompleteBusRoute = CompleteBusRoute()
    var complete571BRoute: CompleteBusRoute = CompleteBusRoute()
    
    var bus511AItinerary:CompleteBusItineray = CompleteBusItineray()
    var bus571BItinerary:CompleteBusItineray = CompleteBusItineray()
    
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
        
        bus511AItinerary.busLineName = complete511ARoute.busLineName
        bus511AItinerary.goingItineraryPoint.appendContentsOf(complete511ARoute.goingPointList)
        bus511AItinerary.returnItineraryPoint.appendContentsOf(complete511ARoute.returnPointList)
        bus511AItinerary.savedDate = NSDate()
        
        bus571BItinerary.busLineName = complete571BRoute.busLineName
        bus571BItinerary.goingItineraryPoint.appendContentsOf(complete571BRoute.goingPointList)
        bus571BItinerary.returnItineraryPoint.appendContentsOf(complete571BRoute.returnPointList)
        bus571BItinerary.savedDate = NSDate()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testResultExistence()
    {
        XCTAssertNotNil(complete511ARoute)
        XCTAssertNotNil(complete571BRoute)
        
        XCTAssertNotNil(bus511AItinerary)
        XCTAssertNotNil(bus571BItinerary)
    }
    
    func testResultUniqueness()
    {
        XCTAssertNotEqual(bus511AItinerary.busLineName, bus571BItinerary.busLineName)
        XCTAssertEqual(bus511AItinerary.busLineName, complete511ARoute.busLineName)
        XCTAssertEqual(bus571BItinerary.busLineName, complete571BRoute.busLineName)
    }
    
    func testResultContents()
    {
        XCTAssertNotNil(bus511AItinerary.busLineName)
        XCTAssert(bus511AItinerary.goingItineraryPoint.count > 0)
        XCTAssert(bus511AItinerary.returnItineraryPoint.count > 0)
        XCTAssertNotNil(bus511AItinerary.savedDate)
        
        XCTAssertNotNil(bus571BItinerary.busLineName)
        XCTAssert(bus571BItinerary.goingItineraryPoint.count > 0)
        XCTAssert(bus571BItinerary.returnItineraryPoint.count > 0)
        XCTAssertNotNil(bus571BItinerary.savedDate)
    }
    
    func testResultForBus511AItineraryValidContents()
    {
        for case let item:RoutePoint in bus511AItinerary.goingItineraryPoint
        {
            XCTAssertNotNil(item.stopId)
            XCTAssertNotNil(item.latitude)
            XCTAssertNotNil(item.longitude)
            XCTAssertNotNil(item.address)
            XCTAssertNotNil(item.isWaypoint)
            XCTAssertNotNil(item.name)
        }
        
        for case let item:RoutePoint in bus511AItinerary.returnItineraryPoint
        {
            XCTAssertNotNil(item.stopId)
            XCTAssertNotNil(item.latitude)
            XCTAssertNotNil(item.longitude)
            XCTAssertNotNil(item.address)
            XCTAssertNotNil(item.isWaypoint)
            XCTAssertNotNil(item.name)
        }
        
    }
    
    func testResultForBus571BItineraryValidContents()
    {
        for case let item:RoutePoint in bus571BItinerary.goingItineraryPoint
        {
            XCTAssertNotNil(item.stopId)
            XCTAssertNotNil(item.latitude)
            XCTAssertNotNil(item.longitude)
            XCTAssertNotNil(item.address)
            XCTAssertNotNil(item.isWaypoint)
            XCTAssertNotNil(item.name)
        }
        
        for case let item:RoutePoint in bus571BItinerary.returnItineraryPoint
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
