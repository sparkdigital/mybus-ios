//
//  SuggestionSearchViewControllerTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 12/1/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
@testable import MYBUS

class SuggestionSearchViewControllerTest: XCTestCase
{
    let suggestionSearchController: SuggestionSearchViewController = SuggestionSearchViewController()
    
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
        XCTAssertNotNil(suggestionSearchController)
        XCTAssertNotNil(suggestionSearchController.bestMatches)
        
        XCTAssertNil(suggestionSearchController.searchSuggestionTableView)
        XCTAssertNil(suggestionSearchController.suggestionsDataSource)
        XCTAssertNil(suggestionSearchController.searchBarController)
        XCTAssertNil(suggestionSearchController.mainViewDelegate)
        XCTAssertNil(suggestionSearchController.searchBar)
    }
    
    func testResultContents()
    {
        let avenues:[SuggestionProtocol] = suggestionSearchController.applyFilter("Av ")
        XCTAssert(avenues.count > 0)
        for case let item:SuggestionProtocol in avenues
        {
            XCTAssertNotNil(item.name)
            XCTAssertNotNil(item.getPoint())
            
            let point:RoutePoint = item.getPoint()
            XCTAssertNotNil(point.stopId)
            XCTAssertNotNil(point.latitude)
            XCTAssertNotNil(point.longitude)
            XCTAssertNotNil(point.address)
            XCTAssertNotNil(point.isWaypoint)
            XCTAssertNotNil(point.name)
        }
        
        let diagonals:[SuggestionProtocol] = suggestionSearchController.applyFilter("Diag ")
        XCTAssert(diagonals.count > 0)
        for case let item:SuggestionProtocol in diagonals
        {
            XCTAssertNotNil(item.name)
            XCTAssertNotNil(item.getPoint())
            
            let point:RoutePoint = item.getPoint()
            XCTAssertNotNil(point.stopId)
            XCTAssertNotNil(point.latitude)
            XCTAssertNotNil(point.longitude)
            XCTAssertNotNil(point.address)
            XCTAssertNotNil(point.isWaypoint)
            XCTAssertNotNil(point.name)
        }
    }
}
