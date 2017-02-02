//
//  BusesResultsTableViewControllerTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 12/1/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
@testable import MYBUS

class BusesResultsTableViewControllerTest: XCTestCase
{
    let busesResultsController: BusesResultsTableViewController = BusesResultsTableViewController()
    
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
        XCTAssertNotNil(busesResultsController)
        XCTAssertNotNil(busesResultsController.buses)
        XCTAssertNotNil(busesResultsController.simpleCellIdentifier)
        XCTAssertNotNil(busesResultsController.combinedCellIdentifier)
        XCTAssertNotNil(busesResultsController.tableView)

        XCTAssertNil(busesResultsController.busSearchResult)
        XCTAssertNil(busesResultsController.mainViewDelegate)
    }
}
