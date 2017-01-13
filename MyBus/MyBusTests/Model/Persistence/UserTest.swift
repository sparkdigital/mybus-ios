//
//  UserTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/9/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import MyBus

class UserTest: XCTestCase
{
    var favourites:[RoutePoint] = []
    var recents:[RoutePoint] = []
    var user:User = User()
    
    override func setUp()
    {
        super.setUp()
        
        // Favourites
        let firstFavouriteFilePath = Bundle(for: UserTest.self).path(forResource: "RoutePointSingle_1_1", ofType: "json")
        let secondFavouriteFilePath = Bundle(for: UserTest.self).path(forResource: "RoutePointSingle_1_2", ofType: "json")
        let thirdFavouriteFilePath = Bundle(for: UserTest.self).path(forResource: "RoutePointSingle_2_1", ofType: "json")
        let fourthFavouriteFilePath = Bundle(for: UserTest.self).path(forResource: "RoutePointSingle_2_2", ofType: "json")
        
        let firstFavouriteJSONData = try! Data(contentsOf: URL(fileURLWithPath: firstFavouriteFilePath!), options:.mappedIfSafe)
        let secondFavouriteJSONData = try! Data(contentsOf: URL(fileURLWithPath: secondFavouriteFilePath!), options:.mappedIfSafe)
        let thirdFavouriteJSONData = try! Data(contentsOf: URL(fileURLWithPath: thirdFavouriteFilePath!), options:.mappedIfSafe)
        let fourthFavouriteJSONData = try! Data(contentsOf: URL(fileURLWithPath: fourthFavouriteFilePath!), options:.mappedIfSafe)
        
        let firstFavouriteJSON = try! JSONSerialization.jsonObject(with: firstFavouriteJSONData, options: .mutableContainers)
        let secondFavouriteJSON = try! JSONSerialization.jsonObject(with: secondFavouriteJSONData, options: .mutableContainers)
        let thirdFavouriteJSON = try! JSONSerialization.jsonObject(with: thirdFavouriteJSONData, options: .mutableContainers)
        let fourthFavouriteJSON = try! JSONSerialization.jsonObject(with: fourthFavouriteJSONData, options: .mutableContainers)
        
        let firstFavouriteDictionary = JSON(firstFavouriteJSON)
        let secondFavouriteDictionary = JSON(secondFavouriteJSON)
        let thirdFavouriteDictionary = JSON(thirdFavouriteJSON)
        let fourthFavouriteDictionary = JSON(fourthFavouriteJSON)
        
        let firstFavourite = RoutePoint.parse(firstFavouriteDictionary)
        let secondFavourite = RoutePoint.parse(secondFavouriteDictionary)
        let thirdFavourite = RoutePoint.parse(thirdFavouriteDictionary)
        let fourthFavourite = RoutePoint.parse(fourthFavouriteDictionary)
        
        favourites = [firstFavourite, secondFavourite, thirdFavourite, fourthFavourite]
        
        // Recents
        let firstRecentFilePath = Bundle(for: UserTest.self).path(forResource: "RoutePointCombined_1_1", ofType: "json")
        let secondRecentFilePath = Bundle(for: UserTest.self).path(forResource: "RoutePointCombined_1_2", ofType: "json")
        let thirdRecentFilePath = Bundle(for: UserTest.self).path(forResource: "RoutePointCombined_2_1", ofType: "json")
        let fourthRecentFilePath = Bundle(for: UserTest.self).path(forResource: "RoutePointCombined_2_2", ofType: "json")
        
        let firstRecentJSONData = try! Data(contentsOf: URL(fileURLWithPath: firstRecentFilePath!), options:.mappedIfSafe)
        let secondRecentJSONData = try! Data(contentsOf: URL(fileURLWithPath: secondRecentFilePath!), options:.mappedIfSafe)
        let thirdRecentJSONData = try! Data(contentsOf: URL(fileURLWithPath: thirdRecentFilePath!), options:.mappedIfSafe)
        let fourthRecentJSONData = try! Data(contentsOf: URL(fileURLWithPath: fourthRecentFilePath!), options:.mappedIfSafe)

        let firstRecentJSON = try! JSONSerialization.jsonObject(with: firstRecentJSONData, options: .mutableContainers)
        let secondRecentJSON = try! JSONSerialization.jsonObject(with: secondRecentJSONData, options: .mutableContainers)
        let thirdRecentJSON = try! JSONSerialization.jsonObject(with: thirdRecentJSONData, options: .mutableContainers)
        let fourthRecentJSON = try! JSONSerialization.jsonObject(with: fourthRecentJSONData, options: .mutableContainers)
        
        let firstRecentDictionary = JSON(firstRecentJSON)
        let secondRecentDictionary = JSON(secondRecentJSON)
        let thirdRecentDictionary = JSON(thirdRecentJSON)
        let fourthRecentDictionary = JSON(fourthRecentJSON)
        
        let firstRecent = RoutePoint.parse(firstRecentDictionary)
        let secondRecent = RoutePoint.parse(secondRecentDictionary)
        let thirdRecent = RoutePoint.parse(thirdRecentDictionary)
        let fourthRecent = RoutePoint.parse(fourthRecentDictionary)
        
        recents = [firstRecent, secondRecent, thirdRecent, fourthRecent]
        
        user.favourites.appendContentsOf(favourites)
        user.recents.appendContentsOf(recents)
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testResultExistence()
    {
        XCTAssertNotNil(user)
    }
    
    func testResultContents()
    {
        XCTAssertNotNil(user.name)
        XCTAssertEqual(user.name, "DeviceiOS")
        XCTAssert(user.favourites.count > 0)
        XCTAssert(user.recents.count > 0)
    }
    
    func testResultForValidContents()
    {
        for case let item:RoutePoint in user.favourites
        {
            XCTAssertNotNil(item.stopId)
            XCTAssertNotNil(item.latitude)
            XCTAssertNotNil(item.longitude)
            XCTAssertNotNil(item.address)
            XCTAssertNotNil(item.isWaypoint)
            XCTAssertNotNil(item.name)
        }
        
        for case let item:RoutePoint in user.recents
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
