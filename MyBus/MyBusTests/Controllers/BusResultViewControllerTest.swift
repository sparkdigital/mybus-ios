//
//  BusResultViewControllerTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 12/1/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import MYBUS

class BusResultViewControllerTest: XCTestCase
{    
    let busResultController:BusResultViewController = BusResultViewController()
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
        
        busResultController.routeResult = busRouteResultSingle.first
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testResultExistence()
    {
        XCTAssertNotNil(busResultController)
    }
    
    func testResultContents()
    {
        XCTAssertNotNil(busResultController.busResultScrollView)
        XCTAssertNotNil(busResultController.routeResult)
    }
    
}
