//
//  MainViewControllerTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 12/1/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
@testable import MyBus

class MainViewControllerTest: XCTestCase
{
    let mainController: MainViewController = MainViewController()
    
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
        XCTAssertNotNil(mainController)
        XCTAssertNotNil(mainController.defaultTabBarHeight)
        XCTAssertNotNil(mainController.progressNotification)
        XCTAssertNotNil(mainController.alertNetworkNotReachable)

        // IBOutlet
        XCTAssertNil(mainController.containerView)
        XCTAssertNil(mainController.locateUserButton)
        XCTAssertNil(mainController.searchToolbar)
        XCTAssertNil(mainController.searchBar)
        XCTAssertNil(mainController.tabBar)
        XCTAssertNil(mainController.mapSearchViewContainer)
        XCTAssertNil(mainController.mapSearchViewHeightConstraint)
        XCTAssertNil(mainController.menuTabBar)
        XCTAssertNil(mainController.menuTabBarHeightConstraint)
        
        // Controllers
        XCTAssertNil(mainController.mapViewModel)
        XCTAssertNil(mainController.mapViewController)
        XCTAssertNil(mainController.searchViewController)
        XCTAssertNil(mainController.suggestionSearchViewController)
        XCTAssertNil(mainController.searchContainerViewController)
        XCTAssertNil(mainController.favoriteViewController)
        XCTAssertNil(mainController.busesRatesViewController)
        XCTAssertNil(mainController.busesInformationViewController)
        XCTAssertNil(mainController.busesResultsTableViewController)
        XCTAssertNil(mainController.navRouter)
        XCTAssertNil(mainController.currentViewController)
        
        // Reachability
        XCTAssertNil(mainController.reachability)
    }
}
