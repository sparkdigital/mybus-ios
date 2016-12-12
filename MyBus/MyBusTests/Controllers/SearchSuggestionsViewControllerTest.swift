//
//  SearchSuggestionsViewControllerTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 12/1/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest

class SearchSuggestionsViewControllerTest: XCTestCase
{
    let searchSuggestionsController: SearchSuggestionsViewController = SearchSuggestionsViewController()
    
    override func setUp()
    {
        super.setUp()
        
        searchSuggestionsController.viewDidLoad()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testResultExistence()
    {
        XCTAssertNotNil(searchSuggestionsController)
        XCTAssertNil(searchSuggestionsController.suggestionsTableView)
    }
    
    func testResultContents()
    {
        XCTAssert(searchSuggestionsController.sampleSearches.count > 0)
    }
}
