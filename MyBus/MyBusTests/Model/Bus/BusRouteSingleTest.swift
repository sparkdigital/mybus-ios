//
//  BusRouteTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/9/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest

class BusRouteTest: XCTestCase
{
    let busRoute1:BusRoute
    let busRoute2:BusRoute
    let busRoute3:BusRoute
    
    override func setUp()
    {
        super.setUp()
        
        let firstFilePath = NSBundle.mainBundle().pathForResource("BusRouteSingle_1", ofType: "json")
        let secondFilePath = NSBundle.mainBundle().pathForResource("BusRouteSingle_2", ofType: "json")
        let thirdFilePath = NSBundle.mainBundle().pathForResource("BusRouteSingle_3", ofType: "json")
        
        let firstJSONData = try! NSData(contentsOfFile: firstFilePath!, options: .DataReadingMappedIfSafe)
        let secondJSONData = try! NSData(contentsOfFile: secondFilePath!, options: .DataReadingMappedIfSafe)
        let thirdJSONData = try! NSData(contentsOfFile: thirdFilePath!, options: .DataReadingMappedIfSafe)
        
        let firstRouteDictionary = try! NSJSONSerialization.JSONObjectWithData(firstJSONData, options: .MutableContainers)
        let secondRouteDictionary = try! NSJSONSerialization.JSONObjectWithData(secondJSONData, options: .MutableContainers)
        let thirdRouteDictionary = try! NSJSONSerialization.JSONObjectWithData(thirdJSONData, options: .MutableContainers)
        
        //busRoute1 = BusRoute
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
