//
//  BusesResultsMenuViewControllerTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 12/1/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import PageMenu
import SwiftyJSON
@testable import MYBUS

class BusesResultsMenuViewControllerTest: XCTestCase
{
    let busesResultsMenuController:BusesResultsMenuViewController = BusesResultsMenuViewController()
    var busRouteResultSingle: [BusRouteResult] = []
    
    override func setUp()
    {
        super.setUp()
        
        let filePath = Bundle(for: BusesResultsMenuViewControllerTest.self).path(forResource: "BusRouteResultSingle_1", ofType: "json")
        
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: filePath!), options:.mappedIfSafe)
        
        let json = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        
        var firstRouteDictionary = JSON(json)
        
        let firstType = firstRouteDictionary["Type"].intValue
        let firstResults = firstRouteDictionary["Results"]
        
        busRouteResultSingle = BusRouteResult.parseResults(firstResults, type: firstType)
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testResultExistence()
    {
        XCTAssertNotNil(busesResultsMenuController)
        XCTAssertNotNil(busesResultsMenuController.controllerArray)
        
        XCTAssertNil(busesResultsMenuController.pageMenu)
        XCTAssertNil(busesResultsMenuController.busRouteOptions)
        XCTAssertNil(busesResultsMenuController.busResultDelegate)
    }
    
    func testResultContents()
    {
        XCTAssertNotNil(busesResultsMenuController.buildControllers(busRouteResultSingle))
        
        let busResultControllers: [BusResultViewController] = busesResultsMenuController.buildControllers(busRouteResultSingle)
        XCTAssert(busResultControllers.count > 0)
        
        for case let item:BusResultViewController in busResultControllers
        {
            XCTAssertNotNil(item)
            XCTAssertNotNil(item.routeResult)
            XCTAssertNotNil(item.busResultScrollView)
        }
    }
}
