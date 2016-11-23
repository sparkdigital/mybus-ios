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
    favourites = List<RoutePoint> ()
    var recents
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
        
        // Recents
        let firstRecentFilePath = NSBundle(forClass: UserTest.self).pathForResource("RoutePointCombined_1_1", ofType: "json")
        let secondRecentFilePath = NSBundle(forClass: UserTest.self).pathForResource("RoutePointCombined_1_2", ofType: "json")
        let thirdRecentFilePath = NSBundle(forClass: UserTest.self).pathForResource("RoutePointCombined_2_1", ofType: "json")
        let fourthRecentFilePath = NSBundle(forClass: UserTest.self).pathForResource("RoutePointCombined_2_2", ofType: "json")
        
        let firstCombinedOriginRoutePointJSONData = try! NSData(contentsOfFile: firstRecentFilePath!, options:.DataReadingMappedIfSafe)
        let firstCombinedDestinationRoutePointJSONData = try! NSData(contentsOfFile: secondRecentFilePath!, options:.DataReadingMappedIfSafe)
        let secondCombinedOriginRoutePointJSONData = try! NSData(contentsOfFile: thirdRecentFilePath!, options:.DataReadingMappedIfSafe)
        let secondCombinedDestinationRoutePointJSONData = try! NSData(contentsOfFile: fourthRecentFilePath!, options:.DataReadingMappedIfSafe)

        let firstCombinedOriginRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(firstCombinedOriginRoutePointJSONData, options: .MutableContainers)
        let firstCombinedDestinationRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(firstCombinedDestinationRoutePointJSONData, options: .MutableContainers)
        let secondCombinedOriginRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(secondCombinedOriginRoutePointJSONData, options: .MutableContainers)
        let secondCombinedDestinationRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(secondCombinedDestinationRoutePointJSONData, options: .MutableContainers)
        
        let firstCombinedOriginRoutePointDictionary = JSON(firstCombinedOriginRoutePointJSON)
        let firstCombinedDestinationRoutePointDictionary = JSON(firstCombinedDestinationRoutePointJSON)
        let secondCombinedOriginRoutePointDictionary = JSON(secondCombinedOriginRoutePointJSON)
        let secondCombinedDestinationRoutePointDictionary = JSON(secondCombinedDestinationRoutePointJSON)
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
}
