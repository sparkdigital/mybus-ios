//
//  SuggestedPlaceTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/10/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
@testable import MyBus

class SuggestedPlaceTest: XCTestCase
{
    var suggestedPlaces: [SuggestedPlace] = []
    
    override func setUp()
    {
        super.setUp()
    
        let suggestedPlacesArray = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("SuggestedPlaces", ofType: "plist")!)!
        
        suggestedPlaces = suggestedPlacesArray.map { (placeDict) -> SuggestedPlace in
            return SuggestedPlace(object: placeDict as! NSDictionary)
        }
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testResultExistence()
    {
        XCTAssertNotNil(suggestedPlaces)
    }
    
    func testResultContents()
    {
        XCTAssert(suggestedPlaces.count > 0)
    }
    
    func testFirstRouteResultSingleForValidContents()
    {
        print("\nSuggested Places:\n")
        
        let suggestedPlacesInConfiguration = Configuration.suggestedPlaces()
        
        for case let item:SuggestedPlace in suggestedPlaces
        {
            let indexOfSuggestedItem = suggestedPlaces.indexOf({$0 === item})
            
            XCTAssertNotNil(item.name)
            XCTAssertNotNil(item.description)
            XCTAssertNotNil(item.address)
            XCTAssertNotNil(item.photoUrl)
            XCTAssertNotNil(item.location.latitude)
            XCTAssertNotNil(item.location.longitude)
            
            XCTAssertEqual(item.name, suggestedPlacesInConfiguration[indexOfSuggestedItem!].name)
            XCTAssertEqual(item.description, suggestedPlacesInConfiguration[indexOfSuggestedItem!].description)
            XCTAssertEqual(item.address, suggestedPlacesInConfiguration[indexOfSuggestedItem!].address)
            XCTAssertEqual(item.photoUrl, suggestedPlacesInConfiguration[indexOfSuggestedItem!].photoUrl)
            XCTAssertEqual(item.location.latitude, suggestedPlacesInConfiguration[indexOfSuggestedItem!].location.latitude)
            XCTAssertEqual(item.location.longitude, suggestedPlacesInConfiguration[indexOfSuggestedItem!].location.longitude)
            
            print("Suggested Place with Name:\(item.name) Description:\(item.description) Address:\(item.address) @ (LAT:\(item.location.latitude),LON:\(item.location.longitude))\n")
        }
    }
}
