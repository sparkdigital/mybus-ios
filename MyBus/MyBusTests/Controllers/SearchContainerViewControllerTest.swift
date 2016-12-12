//
//  SearchContainerViewControllerTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 12/1/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest

class SearchContainerViewControllerTest: XCTestCase
{
    let searchContainerController: SearchContainerViewController = SearchContainerViewController()
    
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
        XCTAssertNotNil(searchContainerController)
        XCTAssertNotNil(searchContainerController.searchType)
        XCTAssertNotNil(searchContainerController.progressNotification)
        
        XCTAssertNil(searchContainerController.shortcutsViewController)
        XCTAssertNil(searchContainerController.suggestionViewController)
        XCTAssertNil(searchContainerController.currentViewController)
        XCTAssertNil(searchContainerController.searchContainerView)
        XCTAssertNil(searchContainerController.addressLocationSearchBar)
        XCTAssertNil(searchContainerController.busRoadDelegate)
    }
}
