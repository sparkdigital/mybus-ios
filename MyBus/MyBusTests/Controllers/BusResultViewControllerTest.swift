//
//  BusResultViewControllerTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 12/1/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import MyBus

class BusResultViewControllerTest: XCTestCase
{    
    let busResultController:BusResultViewController = BusResultViewController()
    var busRouteResultSingle: [BusRouteResult] = []
    
    override func setUp()
    {
        super.setUp()
        
        let filePath = NSBundle(forClass: BusesResultsMenuViewControllerTest.self).pathForResource("BusRouteResultSingle_1", ofType: "json")
        
        let jsonData = try! NSData(contentsOfFile: filePath!, options:.DataReadingMappedIfSafe)
        
        let json = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers)
        
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
