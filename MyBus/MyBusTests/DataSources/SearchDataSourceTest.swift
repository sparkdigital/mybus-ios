//
//  SearchDataSourceTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/30/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest

class SearchDataSourceTest: XCTestCase
{
    let searchDataSource: SearchDataSource = SearchDataSource()
    
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
        XCTAssertNotNil(searchDataSource.favourites)
        XCTAssertNotNil(searchDataSource.recents)
    }
    
    func testResultContents()
    {
        XCTAssert(searchDataSource.favourites.count > 0)
        XCTAssert(searchDataSource.recents.count > 0)
    }
    
    func testResultContentsForValidFavourites()
    {
        for case let item:RoutePoint in searchDataSource.favourites
        {
            XCTAssertNotNil(item.stopId)
            XCTAssertNotNil(item.latitude)
            XCTAssertNotNil(item.longitude)
            XCTAssertNotNil(item.address)
            XCTAssertNotNil(item.isWaypoint)
            XCTAssertNotNil(item.name)
        }
    }
    
    func testResultContentsForValidRecents()
    {
        for case let item:RoutePoint in searchDataSource.recents
        {
            XCTAssertNotNil(item.stopId)
            XCTAssertNotNil(item.latitude)
            XCTAssertNotNil(item.longitude)
            XCTAssertNotNil(item.address)
            XCTAssertNotNil(item.isWaypoint)
            XCTAssertNotNil(item.name)
        }
    }
}
