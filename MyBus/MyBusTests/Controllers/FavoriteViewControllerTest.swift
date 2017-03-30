//
//  FavoriteViewControllerTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 12/1/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
@testable import MYBUS

class FavoriteViewControllerTest: XCTestCase
{
    let favoriteController: FavoriteViewController = FavoriteViewController()
    
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
        XCTAssertNotNil(favoriteController)
        
        XCTAssertNil(favoriteController.favoriteDataSource)
        XCTAssertNil(favoriteController.favoriteTableView)
    }
}
