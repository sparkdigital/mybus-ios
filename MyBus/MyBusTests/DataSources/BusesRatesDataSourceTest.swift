//
//  BusesRatesDataSourceTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/30/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest

class BusesRatesDataSourceTest: XCTestCase
{
    let busesRatesDataSource: BusesRatesDataSource = BusesRatesDataSource()
    
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
        XCTAssertNotNil(busesRatesDataSource.busRate)
    }
}
