//
//  UserTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/9/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import SwiftyJSON

class UserTest: XCTestCase
{
    var favourites:[RoutePoint] = []
    var recents:[RoutePoint] = []
    var user:User = User()
    
    override func setUp()
    {
        super.setUp()
        
        // Favourites
        let firstFavouriteFilePath = NSBundle(forClass: UserTest.self).pathForResource("RoutePointSingle_1_1", ofType: "json")
        let secondFavouriteFilePath = NSBundle(forClass: UserTest.self).pathForResource("RoutePointSingle_1_2", ofType: "json")
        let thirdFavouriteFilePath = NSBundle(forClass: UserTest.self).pathForResource("RoutePointSingle_2_1", ofType: "json")
        let fourthFavouriteFilePath = NSBundle(forClass: UserTest.self).pathForResource("RoutePointSingle_2_2", ofType: "json")
        
        let firstFavouriteJSONData = try! NSData(contentsOfFile: firstFavouriteFilePath!, options:.DataReadingMappedIfSafe)
        let secondFavouriteJSONData = try! NSData(contentsOfFile: secondFavouriteFilePath!, options:.DataReadingMappedIfSafe)
        let thirdFavouriteJSONData = try! NSData(contentsOfFile: thirdFavouriteFilePath!, options:.DataReadingMappedIfSafe)
        let fourthFavouriteJSONData = try! NSData(contentsOfFile: fourthFavouriteFilePath!, options:.DataReadingMappedIfSafe)
        
        let firstFavouriteJSON = try! NSJSONSerialization.JSONObjectWithData(firstFavouriteJSONData, options: .MutableContainers)
        let secondFavouriteJSON = try! NSJSONSerialization.JSONObjectWithData(secondFavouriteJSONData, options: .MutableContainers)
        let thirdFavouriteJSON = try! NSJSONSerialization.JSONObjectWithData(thirdFavouriteJSONData, options: .MutableContainers)
        let fourthFavouriteJSON = try! NSJSONSerialization.JSONObjectWithData(fourthFavouriteJSONData, options: .MutableContainers)
        
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
        let firstRecentFilePath = NSBundle(forClass: UserTest.self).pathForResource("RoutePointCombined_1_1", ofType: "json")
        let secondRecentFilePath = NSBundle(forClass: UserTest.self).pathForResource("RoutePointCombined_1_2", ofType: "json")
        let thirdRecentFilePath = NSBundle(forClass: UserTest.self).pathForResource("RoutePointCombined_2_1", ofType: "json")
        let fourthRecentFilePath = NSBundle(forClass: UserTest.self).pathForResource("RoutePointCombined_2_2", ofType: "json")
        
        let firstRecentJSONData = try! NSData(contentsOfFile: firstRecentFilePath!, options:.DataReadingMappedIfSafe)
        let secondRecentJSONData = try! NSData(contentsOfFile: secondRecentFilePath!, options:.DataReadingMappedIfSafe)
        let thirdRecentJSONData = try! NSData(contentsOfFile: thirdRecentFilePath!, options:.DataReadingMappedIfSafe)
        let fourthRecentJSONData = try! NSData(contentsOfFile: fourthRecentFilePath!, options:.DataReadingMappedIfSafe)

        let firstRecentJSON = try! NSJSONSerialization.JSONObjectWithData(firstRecentJSONData, options: .MutableContainers)
        let secondRecentJSON = try! NSJSONSerialization.JSONObjectWithData(secondRecentJSONData, options: .MutableContainers)
        let thirdRecentJSON = try! NSJSONSerialization.JSONObjectWithData(thirdRecentJSONData, options: .MutableContainers)
        let fourthRecentJSON = try! NSJSONSerialization.JSONObjectWithData(fourthRecentJSONData, options: .MutableContainers)
        
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
