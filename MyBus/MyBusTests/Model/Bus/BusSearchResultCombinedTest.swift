//
//  BusSearchResultTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/10/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import SwiftyJSON

class BusSearchResultTest: XCTestCase
{
    var firstBusRouteResultSingle: [BusRouteResult] = []
    var secondBusRouteResultSingle: [BusRouteResult] = []
    
    var firstBusRouteResultCombined: [BusRouteResult] = []
    var secondBusRouteResultCombined: [BusRouteResult] = []
    
    var firstSingleRoutePoint:RoutePoint = RoutePoint()
    var secondSingleRoutePoint:RoutePoint = RoutePoint()
    var thirdSingleRoutePoint:RoutePoint = RoutePoint()
    var fourthSingleRoutePoint:RoutePoint = RoutePoint()
    
    var firstCombinedRoutePoint:RoutePoint = RoutePoint()
    var secondCombinedRoutePoint:RoutePoint = RoutePoint()
    var thirdCombinedRoutePoint:RoutePoint = RoutePoint()
    var fourthCombinedRoutePoint:RoutePoint = RoutePoint()
    
    var firstBusSearchResultSingle: BusSearchResult = BusSearchResult()!
    var secondBusSearchResultSingle: BusSearchResult = BusSearchResult()!
    
    var firstBusSearchResultCombined: BusSearchResult = BusSearchResult()!
    var secondBusSearchResultCombined: BusSearchResult = BusSearchResult()!
    
    override func setUp()
    {
        super.setUp()
        
        let firstSingleRouteFilePath = NSBundle(forClass: BusSearchResultTest.self).pathForResource("BusRouteResultSingle_1", ofType: "json")
        let secondSingleRouteFilePath = NSBundle(forClass: BusSearchResultTest.self).pathForResource("BusRouteResultSingle_2", ofType: "json")
        
        let firstCombinedRouteFilePath = NSBundle(forClass: BusSearchResultTest.self).pathForResource("BusRouteResultCombined_1", ofType: "json")
        let secondCombinedRouteFilePath = NSBundle(forClass: BusSearchResultTest.self).pathForResource("BusRouteResultCombined_2", ofType: "json")
        
        let firstSingleRoutePointFilePath = NSBundle(forClass: BusSearchResultTest.self).pathForResource("RoutePointSingle_1_1", ofType: "json")
        let secondSingleRoutePointFilePath = NSBundle(forClass: BusSearchResultTest.self).pathForResource("RoutePointSingle_1_2", ofType: "json")
        let thirdSingleRoutePointFilePath = NSBundle(forClass: BusSearchResultTest.self).pathForResource("RoutePointSingle_2_1", ofType: "json")
        let fourthSingleRoutePointFilePath = NSBundle(forClass: BusSearchResultTest.self).pathForResource("RoutePointSingle_2_2", ofType: "json")
        
        let firstCombinedRoutePointFilePath = NSBundle(forClass: BusSearchResultTest.self).pathForResource("RoutePointCombined_1_1", ofType: "json")
        let secondCombinedRoutePointFilePath = NSBundle(forClass: BusSearchResultTest.self).pathForResource("RoutePointCombined_1_1", ofType: "json")
        let thirdCombinedRoutePointFilePath = NSBundle(forClass: BusSearchResultTest.self).pathForResource("RoutePointCombined_1_1", ofType: "json")
        let fourthCombinedRoutePointFilePath = NSBundle(forClass: BusSearchResultTest.self).pathForResource("RoutePointCombined_1_1", ofType: "json")
        
        // Single Routes
        let firstSingleRouteJSONData = try! NSData(contentsOfFile: firstSingleRouteFilePath!, options:.DataReadingMappedIfSafe)
        let secondSingleRouteJSONData = try! NSData(contentsOfFile: secondSingleRouteFilePath!, options:.DataReadingMappedIfSafe)
        
        let firstSingleRouteJSON = try! NSJSONSerialization.JSONObjectWithData(firstSingleRouteJSONData, options: .MutableContainers)
        let secondSingleRouteJSON = try! NSJSONSerialization.JSONObjectWithData(secondSingleRouteJSONData, options: .MutableContainers)
        
        var firstSingleRouteDictionary = JSON(firstSingleRouteJSON)
        var secondSingleRouteDictionary = JSON(secondSingleRouteJSON)
        
        let firstSingleRouteType = firstSingleRouteDictionary["Type"].intValue
        let firstSingleRouteResults = firstSingleRouteDictionary["Results"]
        
        let secondSingleRouteType = secondSingleRouteDictionary["Type"].intValue
        let secondSingleRouteResults = secondSingleRouteDictionary["Results"]
        
        // Combined Routes
        let firstCombinedRouteJSONData = try! NSData(contentsOfFile: firstCombinedRouteFilePath!, options:.DataReadingMappedIfSafe)
        let secondCombinedRouteJSONData = try! NSData(contentsOfFile: secondCombinedRouteFilePath!, options:.DataReadingMappedIfSafe)
        
        let firstCombinedRouteJSON = try! NSJSONSerialization.JSONObjectWithData(firstCombinedRouteJSONData, options: .MutableContainers)
        let secondCombinedRouteJSON = try! NSJSONSerialization.JSONObjectWithData(secondCombinedRouteJSONData, options: .MutableContainers)
        
        var firstCombinedRouteDictionary = JSON(firstCombinedRouteJSON)
        var secondCombinedRouteDictionary = JSON(secondCombinedRouteJSON)
        
        let firstCombinedRouteType = firstCombinedRouteDictionary["Type"].intValue
        let firstCombinedRouteResults = firstCombinedRouteDictionary["Results"]
        
        let secondCombinedRouteType = secondCombinedRouteDictionary["Type"].intValue
        let secondCombinedRouteResults = secondCombinedRouteDictionary["Results"]
        
        // Single Routes' Points
        let firstSingleRoutePointJSONData = try! NSData(contentsOfFile: firstSingleRoutePointFilePath!, options:.DataReadingMappedIfSafe)
        let secondSingleRoutePointJSONData = try! NSData(contentsOfFile: secondSingleRoutePointFilePath!, options:.DataReadingMappedIfSafe)
        let thirdSingleRoutePointJSONData = try! NSData(contentsOfFile: thirdSingleRoutePointFilePath!, options:.DataReadingMappedIfSafe)
        let fourthSingleRoutePointJSONData = try! NSData(contentsOfFile: fourthSingleRoutePointFilePath!, options:.DataReadingMappedIfSafe)
        
        let firstSingleRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(firstSingleRoutePointJSONData, options: .MutableContainers)
        let secondSingleRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(secondSingleRoutePointJSONData, options: .MutableContainers)
        let thirdSingleRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(thirdSingleRoutePointJSONData, options: .MutableContainers)
        let fourthSingleRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(fourthSingleRoutePointJSONData, options: .MutableContainers)
        
        let firstSingleRoutePointDictionary = JSON(firstSingleRoutePointJSON)
        let secondSingleRoutePointDictionary = JSON(secondSingleRoutePointJSON)
        let thirdSingleRouteDictionary = JSON(thirdSingleRoutePointJSON)
        let fourthSingleRouteDictionary = JSON(fourthSingleRoutePointJSON)
        
        // Combined Routes' Points
        let firstCombinedRoutePointJSONData = try! NSData(contentsOfFile: firstCombinedRoutePointFilePath!, options:.DataReadingMappedIfSafe)
        let secondCombinedRoutePointJSONData = try! NSData(contentsOfFile: secondCombinedRoutePointFilePath!, options:.DataReadingMappedIfSafe)
        let thirdCombinedRoutePointJSONData = try! NSData(contentsOfFile: thirdCombinedRoutePointFilePath!, options:.DataReadingMappedIfSafe)
        let fourthCombinedRoutePointJSONData = try! NSData(contentsOfFile: fourthCombinedRoutePointFilePath!, options:.DataReadingMappedIfSafe)
        
        let firstCombinedRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(firstCombinedRoutePointJSONData, options: .MutableContainers)
        let secondCombinedRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(secondCombinedRoutePointJSONData, options: .MutableContainers)
        let thirdCombinedRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(thirdCombinedRoutePointJSONData, options: .MutableContainers)
        let fourthCombinedRoutePointJSON = try! NSJSONSerialization.JSONObjectWithData(fourthCombinedRoutePointJSONData, options: .MutableContainers)
        
        let firstCombinedRoutePointDictionary = JSON(firstCombinedRoutePointJSON)
        let secondCombinedRoutePointDictionary = JSON(secondCombinedRoutePointJSON)
        let thirdCombinedRoutePointDictionary = JSON(thirdCombinedRoutePointJSON)
        let fourthCombinedRoutePointDictionary = JSON(fourthCombinedRoutePointJSON)
        
        // For logging purposes
        //print("1st BusRouteResult: \(firstRouteDictionary)")
        //print("2nd BusRouteResult: \(secondRouteDictionary)")
        
        firstBusRouteResultSingle = BusRouteResult.parseResults(firstSingleRouteResults, type: firstSingleRouteType)
        secondBusRouteResultSingle = BusRouteResult.parseResults(secondSingleRouteResults, type: secondSingleRouteType)
        
        firstBusRouteResultCombined = BusRouteResult.parseResults(firstCombinedRouteResults, type: firstCombinedRouteType)
        secondBusRouteResultCombined = BusRouteResult.parseResults(secondCombinedRouteResults, type: secondCombinedRouteType)

        firstSingleRoutePoint = RoutePoint.parse(firstSingleRoutePointDictionary)
        secondSingleRoutePoint = RoutePoint.parse(secondSingleRoutePointDictionary)
        thirdSingleRoutePoint = RoutePoint.parse(thirdSingleRouteDictionary)
        fourthSingleRoutePoint = RoutePoint.parse(fourthSingleRouteDictionary)
        
        firstCombinedRoutePoint = RoutePoint.parse(firstCombinedRoutePointDictionary)
        secondCombinedRoutePoint = RoutePoint.parse(secondCombinedRoutePointDictionary)
        thirdCombinedRoutePoint = RoutePoint.parse(thirdCombinedRoutePointDictionary)
        fourthCombinedRoutePoint = RoutePoint.parse(fourthCombinedRoutePointDictionary)
        
        firstBusSearchResultSingle = BusSearchResult(origin: firstSingleRoutePoint, destination: secondSingleRoutePoint, busRoutes: firstBusRouteResultSingle)
        secondBusSearchResultSingle = BusSearchResult(origin: thirdSingleRoutePoint, destination: fourthSingleRoutePoint, busRoutes: secondBusRouteResultSingle)
        
        firstBusSearchResultCombined = BusSearchResult(origin: firstCombinedRoutePoint, destination: secondCombinedRoutePoint, busRoutes: firstBusRouteResultCombined)
        secondBusSearchResultCombined = BusSearchResult(origin: thirdCombinedRoutePoint, destination: fourthCombinedRoutePoint, busRoutes: secondBusRouteResultCombined)
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
}
