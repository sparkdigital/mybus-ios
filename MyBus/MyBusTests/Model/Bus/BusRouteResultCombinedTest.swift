//
//  BusCombinedRouteResultTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/16/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest

class BusCombinedRouteResultTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        let firstFilePath = NSBundle.mainBundle().pathForResource("BusRouteSingle_1", ofType: "json")
        let secondFilePath = NSBundle.mainBundle().pathForResource("BusRouteSingle_2", ofType: "json")
        let thirdFilePath = NSBundle.mainBundle().pathForResource("BusRouteSingle_3", ofType: "json")
        
        let firstJSONData = try! NSData(contentsOfFile: firstFilePath!, options: .DataReadingMappedIfSafe)
        let secondJSONData = try! NSData(contentsOfFile: secondFilePath!, options: .DataReadingMappedIfSafe)
        let thirdJSONData = try! NSData(contentsOfFile: thirdFilePath!, options: .DataReadingMappedIfSafe)
        
        let firstRouteDictionary = try! NSJSONSerialization.JSONObjectWithData(firstJSONData, options: .MutableContainers)
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
