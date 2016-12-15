//
//  MyBusMapControllerTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 12/1/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
@testable import MyBus

class MyBusMapControllerTest: XCTestCase
{
    let myBusMapController: MyBusMapController = MyBusMapController()
    
    override func setUp()
    {
        super.setUp()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testResultExistence()
    {
        XCTAssertNotNil(myBusMapController)
        XCTAssertNotNil(myBusMapController.busResultsDetail)
        XCTAssertNotNil(myBusMapController.progressNotification)
        
        XCTAssertNil(myBusMapController.mapView)
        XCTAssertNil(myBusMapController.roadRouteContainerHeight)
        XCTAssertNil(myBusMapController.roadRouteContainerView)
        XCTAssertNil(myBusMapController.busesSearchOptions)
        XCTAssertNil(myBusMapController.destination)
        XCTAssertNil(myBusMapController.currentRouteDisplayed)
        XCTAssertNil(myBusMapController.mapModel)
    }
}
