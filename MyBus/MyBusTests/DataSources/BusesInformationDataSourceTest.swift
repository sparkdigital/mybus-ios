//
//  BusesInformationDataSourceTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/30/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest

class BusesInformationDataSourceTest: XCTestCase
{
    let busesInformationDataSource: BusesInformationDataSource = BusesInformationDataSource()
    
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
        XCTAssertNotNil(busesInformationDataSource.busInformation)
    }
}
