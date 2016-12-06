//
//  BusesInformationViewControllerTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 12/1/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import MyBus

class BusesInformationViewControllerTest: XCTestCase {
    
    let busesInformationController: BusesInformationViewController = BusesInformationViewController()
    
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
        XCTAssertNotNil(busesInformationController)
        XCTAssertNotNil(busesInformationController.progressNotification)
        
        XCTAssertNil(busesInformationController.busesInformationDataSource)
        XCTAssertNil(busesInformationController.informationTableView)
        XCTAssertNil(busesInformationController.searchViewProtocol)
    }
}
