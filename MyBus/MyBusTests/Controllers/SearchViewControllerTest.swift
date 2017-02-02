//
//  SearchViewControllerTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 12/1/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
@testable import MYBUS

class SearchViewControllerTest: XCTestCase {
    
    let searchController: SearchViewController = SearchViewController()
    
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
        XCTAssertNotNil(searchController)
        XCTAssertNotNil(searchController.busResults)
        XCTAssertNotNil(searchController.bestMatches)
        XCTAssertNotNil(searchController.progressNotification)
        
        XCTAssertNotNil(searchController.kSearchBarNavBarHeight)
        XCTAssertEqual(searchController.kSearchBarNavBarHeight, 140.0)
        XCTAssertNotNil(searchController.kMinimumKeyboardHeight)
        XCTAssertEqual(searchController.kMinimumKeyboardHeight, 356.0)
        
        XCTAssert(!searchController.isSearching)
        
        XCTAssertNil(searchController.searchTableView)
        XCTAssertNil(searchController.mainViewDelegate)
        XCTAssertNil(searchController.favourites)
        XCTAssertNil(searchController.streetSuggestionsDataSource)
    }
}
