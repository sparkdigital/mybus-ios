//
//  BusesRatesViewControllerTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 12/1/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
@testable import MYBUS

class BusesRatesViewControllerTest: XCTestCase {
    
    let busesRatesController: BusesRatesViewController = BusesRatesViewController()
    
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
        XCTAssertNotNil(busesRatesController)
        
        XCTAssertNil(busesRatesController.busesRatesDataSource)
        XCTAssertNil(busesRatesController.ratesTableView)
    }
}
