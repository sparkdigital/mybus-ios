//
//  SearchSuggestionsDataSourceTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/30/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
@testable import MYBUS

class SearchSuggestionsDataSourceTest: XCTestCase
{
    let searchSuggestionDataSource: SearchSuggestionsDataSource = SearchSuggestionsDataSource()
    
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
        XCTAssertNotNil(searchSuggestionDataSource.bestMatches)
    }
}
