//
//  FavoriteDataSourceTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/30/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
@testable import MyBus

class FavoriteDataSourceTest: XCTestCase
{
    let favoriteDataSource: FavoriteDataSource = FavoriteDataSource()
    
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
        XCTAssertNotNil(favoriteDataSource.favorite)
    }
}
