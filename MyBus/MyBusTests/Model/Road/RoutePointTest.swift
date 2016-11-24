//
//  RoutePointTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/10/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import SwiftyJSON

class RoutePointTest: XCTestCase
{
    var firstSingleOriginRoutePoint:RoutePoint = RoutePoint()
    var firstSingleDestinationRoutePoint:RoutePoint = RoutePoint()
    var secondSingleOriginRoutePoint:RoutePoint = RoutePoint()
    var secondSingleDestinationRoutePoint:RoutePoint = RoutePoint()
    
    var firstCombinedOriginRoutePoint:RoutePoint = RoutePoint()
    var firstCombinedDestinationRoutePoint:RoutePoint = RoutePoint()
    var secondCombinedOriginRoutePoint:RoutePoint = RoutePoint()
    var secondCombinedDestinationRoutePoint:RoutePoint = RoutePoint()
    
    override func setUp()
    {
        super.setUp()
        
        // Single Routes' Points
        let firstSingleOriginRoutePointFilePath = NSBundle(forClass: BusSearchResultSingleTest.self).pathForResource("RoutePointSingle_1_1", ofType: "json")
        let firstSingleDestinationRoutePointFilePath = NSBundle(forClass: BusSearchResultSingleTest.self).pathForResource("RoutePointSingle_1_2", ofType: "json")
        let secondSingleOriginRoutePointFilePath = NSBundle(forClass: BusSearchResultSingleTest.self).pathForResource("RoutePointSingle_2_1", ofType: "json")
        let secondSingleDestinationRoutePointFilePath = NSBundle(forClass: BusSearchResultSingleTest.self).pathForResource("RoutePointSingle_2_2", ofType: "json")
        
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
        
        // Combined Routes' Points
        let firstCombinedOriginRoutePointFilePath = NSBundle(forClass: BusSearchResultCombinedTest.self).pathForResource("RoutePointCombined_1_1", ofType: "json")
        let firstCombinedDestinationRoutePointFilePath = NSBundle(forClass: BusSearchResultCombinedTest.self).pathForResource("RoutePointCombined_1_2", ofType: "json")
        let secondCombinedOriginRoutePointFilePath = NSBundle(forClass: BusSearchResultCombinedTest.self).pathForResource("RoutePointCombined_2_1", ofType: "json")
        let secondCombinedDestinationRoutePointFilePath = NSBundle(forClass: BusSearchResultCombinedTest.self).pathForResource("RoutePointCombined_2_2", ofType: "json")
        
        let firstCombinedOriginRoutePointJSONData = try! NSData(contentsOfFile: firstCombinedOriginRoutePointFilePath!, options:.DataReadingMappedIfSafe)
        let firstCombinedDestinationRoutePointJSONData = try! NSData(contentsOfFile: firstCombinedDestinationRoutePointFilePath!, options:.DataReadingMappedIfSafe)
        let secondCombinedOriginRoutePointJSONData = try! NSData(contentsOfFile: secondCombinedOriginRoutePointFilePath!, options:.DataReadingMappedIfSafe)
        let secondCombinedDestinationRoutePointJSONData = try! NSData(contentsOfFile: secondCombinedDestinationRoutePointFilePath!, options:.DataReadingMappedIfSafe)
        
        let firstCombinedOriginRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(firstCombinedOriginRoutePointJSONData, options: .MutableContainers)
        let firstCombinedDestinationRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(firstCombinedDestinationRoutePointJSONData, options: .MutableContainers)
        let secondCombinedOriginRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(secondCombinedOriginRoutePointJSONData, options: .MutableContainers)
        let secondCombinedDestinationRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(secondCombinedDestinationRoutePointJSONData, options: .MutableContainers)
        
        let firstCombinedOriginRoutePointDictionary = JSON(firstCombinedOriginRoutePointJSON)
        let firstCombinedDestinationRoutePointDictionary = JSON(firstCombinedDestinationRoutePointJSON)
        let secondCombinedOriginRoutePointDictionary = JSON(secondCombinedOriginRoutePointJSON)
        let secondCombinedDestinationRoutePointDictionary = JSON(secondCombinedDestinationRoutePointJSON)
        
        // For logging purposes - Single
        /*
         print("1st OriginRoutePoint: \(firstSingleOriginRoutePointDictionary)")
         print("1st DestinationRoutePoint: \(firstSingleDestinationRoutePointDictionary)")
         print("2nd OriginRoutePoint: \(secondSingleOriginRouteDictionary)")
         print("2nd DestinationRoutePoint: \(secondSingleDestinationRouteDictionary)")
         */
        
        firstSingleOriginRoutePoint = RoutePoint.parse(firstSingleOriginRoutePointDictionary)
        firstSingleDestinationRoutePoint = RoutePoint.parse(firstSingleDestinationRoutePointDictionary)
        secondSingleOriginRoutePoint = RoutePoint.parse(secondSingleOriginRouteDictionary)
        secondSingleDestinationRoutePoint = RoutePoint.parse(secondSingleDestinationRouteDictionary)
        
        // For logging purposes - Combined
        /*
         print("1st OriginRoutePoint: \(firstCombinedOriginRoutePointDictionary)")
         print("1st DestinationRoutePoint: \(firstCombinedDestinationRoutePointDictionary)")
         print("2nd OriginRoutePoint: \(secondCombinedOriginRoutePointDictionary)")
         print("2nd DestinationRoutePoint: \(secondCombinedDestinationRoutePointDictionary)")
         */
        
        firstCombinedOriginRoutePoint = RoutePoint.parse(firstCombinedOriginRoutePointDictionary)
        firstCombinedDestinationRoutePoint = RoutePoint.parse(firstCombinedDestinationRoutePointDictionary)
        secondCombinedOriginRoutePoint = RoutePoint.parse(secondCombinedOriginRoutePointDictionary)
        secondCombinedDestinationRoutePoint = RoutePoint.parse(secondCombinedDestinationRoutePointDictionary)
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testResultExistence()
    {
        XCTAssertNotNil(firstSingleOriginRoutePoint)
        XCTAssertNotNil(firstSingleDestinationRoutePoint)
        XCTAssertNotNil(secondSingleOriginRoutePoint)
        XCTAssertNotNil(secondSingleDestinationRoutePoint)
        
        XCTAssertNotNil(firstCombinedOriginRoutePoint)
        XCTAssertNotNil(firstCombinedDestinationRoutePoint)
        XCTAssertNotNil(secondCombinedOriginRoutePoint)
        XCTAssertNotNil(secondCombinedDestinationRoutePoint)
    }
    
    func testResultUniqueness()
    {
        XCTAssertNotEqual(firstSingleOriginRoutePoint, firstSingleDestinationRoutePoint)
        XCTAssertNotEqual(firstSingleOriginRoutePoint, secondSingleOriginRoutePoint)
        XCTAssertNotEqual(firstSingleOriginRoutePoint, secondSingleDestinationRoutePoint)
        XCTAssertNotEqual(firstSingleOriginRoutePoint, firstCombinedOriginRoutePoint)
        XCTAssertNotEqual(firstSingleOriginRoutePoint, firstCombinedDestinationRoutePoint)
        XCTAssertNotEqual(firstSingleOriginRoutePoint, secondCombinedOriginRoutePoint)
        XCTAssertNotEqual(firstSingleOriginRoutePoint, secondCombinedDestinationRoutePoint)
        
        XCTAssertNotEqual(firstSingleDestinationRoutePoint, secondSingleOriginRoutePoint)
        XCTAssertNotEqual(firstSingleDestinationRoutePoint, secondSingleDestinationRoutePoint)
        XCTAssertNotEqual(firstSingleDestinationRoutePoint, firstCombinedOriginRoutePoint)
        XCTAssertNotEqual(firstSingleDestinationRoutePoint, firstCombinedDestinationRoutePoint)
        XCTAssertNotEqual(firstSingleDestinationRoutePoint, secondCombinedOriginRoutePoint)
        XCTAssertNotEqual(firstSingleDestinationRoutePoint, secondCombinedDestinationRoutePoint)
        
        XCTAssertNotEqual(secondSingleOriginRoutePoint, secondSingleDestinationRoutePoint)
        XCTAssertNotEqual(secondSingleOriginRoutePoint, firstCombinedOriginRoutePoint)
        XCTAssertNotEqual(secondSingleOriginRoutePoint, firstCombinedDestinationRoutePoint)
        XCTAssertNotEqual(secondSingleOriginRoutePoint, secondCombinedOriginRoutePoint)
        XCTAssertNotEqual(secondSingleOriginRoutePoint, secondCombinedDestinationRoutePoint)
        
        XCTAssertNotEqual(secondSingleDestinationRoutePoint, firstCombinedOriginRoutePoint)
        XCTAssertNotEqual(secondSingleDestinationRoutePoint, firstCombinedDestinationRoutePoint)
        XCTAssertNotEqual(secondSingleDestinationRoutePoint, secondCombinedOriginRoutePoint)
        XCTAssertNotEqual(secondSingleDestinationRoutePoint, secondCombinedDestinationRoutePoint)
        
        XCTAssertNotEqual(firstCombinedOriginRoutePoint, firstCombinedDestinationRoutePoint)
        XCTAssertNotEqual(firstCombinedOriginRoutePoint, secondCombinedOriginRoutePoint)
        XCTAssertNotEqual(firstCombinedOriginRoutePoint, secondCombinedDestinationRoutePoint)
        
        XCTAssertNotEqual(firstCombinedDestinationRoutePoint, secondCombinedOriginRoutePoint)
        XCTAssertNotEqual(firstCombinedDestinationRoutePoint, secondCombinedDestinationRoutePoint)
        
        XCTAssertNotEqual(secondCombinedOriginRoutePoint, secondCombinedDestinationRoutePoint)
    }

    func testFirstSingleOriginRoutePointsForValidContents()
    {
        XCTAssertNotNil(firstSingleOriginRoutePoint.stopId)
        XCTAssertNotNil(firstSingleOriginRoutePoint.latitude)
        XCTAssertNotNil(firstSingleOriginRoutePoint.longitude)
        XCTAssertNotNil(firstSingleOriginRoutePoint.address)
        XCTAssertNotNil(firstSingleOriginRoutePoint.isWaypoint)
        XCTAssertNotNil(firstSingleOriginRoutePoint.name)
    }
    
    func testFirstSingleDestinationRoutePointsForValidContents()
    {
        XCTAssertNotNil(firstSingleDestinationRoutePoint.stopId)
        XCTAssertNotNil(firstSingleDestinationRoutePoint.latitude)
        XCTAssertNotNil(firstSingleDestinationRoutePoint.longitude)
        XCTAssertNotNil(firstSingleDestinationRoutePoint.address)
        XCTAssertNotNil(firstSingleDestinationRoutePoint.isWaypoint)
        XCTAssertNotNil(firstSingleDestinationRoutePoint.name)
    }
    
    func testSecondSingleOriginRoutePointsForValidContents()
    {
        XCTAssertNotNil(secondSingleOriginRoutePoint.stopId)
        XCTAssertNotNil(secondSingleOriginRoutePoint.latitude)
        XCTAssertNotNil(secondSingleOriginRoutePoint.longitude)
        XCTAssertNotNil(secondSingleOriginRoutePoint.address)
        XCTAssertNotNil(secondSingleOriginRoutePoint.isWaypoint)
        XCTAssertNotNil(secondSingleOriginRoutePoint.name)
    }
    
    func testSecondSingleDestinationRoutePointsForValidContents()
    {
        XCTAssertNotNil(secondSingleDestinationRoutePoint.stopId)
        XCTAssertNotNil(secondSingleDestinationRoutePoint.latitude)
        XCTAssertNotNil(secondSingleDestinationRoutePoint.longitude)
        XCTAssertNotNil(secondSingleDestinationRoutePoint.address)
        XCTAssertNotNil(secondSingleDestinationRoutePoint.isWaypoint)
        XCTAssertNotNil(secondSingleDestinationRoutePoint.name)
    }
    
    func testFirstCombinedOriginRoutePointsForValidContents()
    {
        XCTAssertNotNil(firstCombinedOriginRoutePoint.stopId)
        XCTAssertNotNil(firstCombinedOriginRoutePoint.latitude)
        XCTAssertNotNil(firstCombinedOriginRoutePoint.longitude)
        XCTAssertNotNil(firstCombinedOriginRoutePoint.address)
        XCTAssertNotNil(firstCombinedOriginRoutePoint.isWaypoint)
        XCTAssertNotNil(firstCombinedOriginRoutePoint.name)
    }
    
    func testFirstCombinedDestinationRoutePointsForValidContents()
    {
        XCTAssertNotNil(firstCombinedDestinationRoutePoint.stopId)
        XCTAssertNotNil(firstCombinedDestinationRoutePoint.latitude)
        XCTAssertNotNil(firstCombinedDestinationRoutePoint.longitude)
        XCTAssertNotNil(firstCombinedDestinationRoutePoint.address)
        XCTAssertNotNil(firstCombinedDestinationRoutePoint.isWaypoint)
        XCTAssertNotNil(firstCombinedDestinationRoutePoint.name)
    }
    
    func testSecondCombinedOriginRoutePointsForValidContents()
    {
        XCTAssertNotNil(secondCombinedOriginRoutePoint.stopId)
        XCTAssertNotNil(secondCombinedOriginRoutePoint.latitude)
        XCTAssertNotNil(secondCombinedOriginRoutePoint.longitude)
        XCTAssertNotNil(secondCombinedOriginRoutePoint.address)
        XCTAssertNotNil(secondCombinedOriginRoutePoint.isWaypoint)
        XCTAssertNotNil(secondCombinedOriginRoutePoint.name)
    }
    
    func testSecondCombinedDestinationRoutePointsForValidContents()
    {
        XCTAssertNotNil(secondCombinedDestinationRoutePoint.stopId)
        XCTAssertNotNil(secondCombinedDestinationRoutePoint.latitude)
        XCTAssertNotNil(secondCombinedDestinationRoutePoint.longitude)
        XCTAssertNotNil(secondCombinedDestinationRoutePoint.address)
        XCTAssertNotNil(secondCombinedDestinationRoutePoint.isWaypoint)
        XCTAssertNotNil(secondCombinedDestinationRoutePoint.name)
    }
    
}
