//
//  RechargePointTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/10/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import SwiftyJSON

class RechargePointTest: XCTestCase
{
    var rechargePoints: [RechargePoint] = []
    
    override func setUp()
    {
        super.setUp()
        
        let filePath = NSBundle(forClass: BusRouteSingleTest.self).pathForResource("RechargePoints_1", ofType: "json")
        
        let rechargePointsJSONData = try! NSData(contentsOfFile: filePath!, options:.DataReadingMappedIfSafe)
        let rechargePointsJSON = try! NSJSONSerialization.JSONObjectWithData(rechargePointsJSONData, options: .MutableContainers)
        
        var rechargePointsDictionary = JSON(rechargePointsJSON)
        let rechargePointsResults = rechargePointsDictionary["Results"]
        
        rechargePoints = rechargePointsResults.arrayValue.map { (point: JSON) -> RechargePoint in
            RechargePoint(json: point)!
        }
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testResultExistence()
    {
        XCTAssertNotNil(rechargePoints)
    }
    
    func testResultContents()
    {
        XCTAssert(rechargePoints.count > 0)
    }
    
    func testRechargePointsForValidContents()
    {
        print("\nNearby Recharge Points:\n")
        for case let item:RechargePoint in rechargePoints
        {
            XCTAssertNotNil(item)
            
            XCTAssertNotNil(item.id)
            XCTAssertNotNil(item.name)
            XCTAssertNotNil(item.address)
            XCTAssertNotNil(item.location)
            XCTAssertNotNil(item.openTime)
            XCTAssertNotNil(item.distance)
            
            XCTAssertGreaterThanOrEqual(item.distance!, 0.0)
        }
    }
}
