//
//  RechargePointTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/10/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import MyBus

class RechargePointTest: XCTestCase
{
    var rechargePoints: [RechargePoint] = []

    override func setUp()
    {
        super.setUp()

        let filePath = Bundle(for: BusRouteSingleTest.self).path(forResource: "RechargePoints_1", ofType: "json")

        let rechargePointsJSONData = try! Data(contentsOf: URL(fileURLWithPath: filePath!), options:.mappedIfSafe)
        let rechargePointsJSON = try! JSONSerialization.jsonObject(with: rechargePointsJSONData, options: .mutableContainers)

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
        for case let item: RechargePoint in rechargePoints
        {
            XCTAssertNotNil(item)

            XCTAssertNotNil(item.id)
            XCTAssertNotNil(item.name)
            XCTAssertNotNil(item.address)
            XCTAssertNotNil(item.location)
            XCTAssertNotNil(item.openTime)
            XCTAssertNotNil(item.distance)
            XCTAssertNotNil(item.isOpen)

            XCTAssertGreaterThanOrEqual(item.distance!, 0.0)

            print("Recharge Point: ID - \(item.id) @ Address: \(item.address)(LAT: \(item.getLatLong().latitude),LON: \(item.getLatLong().longitude))\n")
        }
    }
}
