//
//  RoadResultTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/10/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import SwiftyJSON

class RoadResultTest: XCTestCase
{
    var roadResult:RoadResult = RoadResult()
    
    override func setUp()
    {
        super.setUp()
        
        let filePath = NSBundle(forClass: BusRouteSingleTest.self).pathForResource("RoadResult_1", ofType: "json")
        
        let jsonData = try! NSData(contentsOfFile: filePath!, options:.DataReadingMappedIfSafe)
        
        let json = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers)
        
        let roadResultDictionary = JSON(json)
        
        roadResult = RoadResult.parse(roadResultDictionary)
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testResultExistence()
    {
        XCTAssertNotNil(roadResult)
    }
    
    func testResultContents()
    {
        XCTAssertNotNil(roadResult.roadResultType)
        XCTAssertNotNil(roadResult.totalDistances)
        XCTAssertNotNil(roadResult.travelTime)
        XCTAssertNotNil(roadResult.arrivalTime)
        XCTAssertNotNil(roadResult.idBusLine1)
        XCTAssertNotNil(roadResult.idBusLine2)
        
        XCTAssert(roadResult.routeList.count > 0)
        XCTAssert(roadResult.getPointList().count > 0)
        
        switch roadResult.busRouteResultType()
        {
        case .Single:
            XCTAssertNotNil(roadResult.firstBusStop)
            XCTAssertNotNil(roadResult.endBusStop)
        case .Combined:
            XCTAssertNotNil(roadResult.midStartStop)
            XCTAssertNotNil(roadResult.midEndStop)
        }
        
        XCTAssertNotEqual(roadResult.firstBusStop?.latitude, roadResult.midEndStop?.latitude)
        XCTAssertNotEqual(roadResult.firstBusStop?.longitude, roadResult.midEndStop?.longitude)
        
        for case let item:RoutePoint in roadResult.getPointList()
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
