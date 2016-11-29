//
//  GisServiceTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/24/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import MapKit

class GisServiceTest: XCTestCase
{
    let mgpGISService = GisService()
    
    var bestMatches: [SearchSuggestion] = []
    var searchText: String = ""
    
    override func setUp()
    {
        super.setUp()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testResultContentsForAvenuesSearch()
    {
        searchText = "Av "
        
        let avenuesExpectation = expectationWithDescription("GISServiceGatherAllAvenuesNames")
        
        mgpGISService.getStreetNamesByFile(forName: searchText)
        { (streets, error) in
            if let streets = streets
            {
                for street in streets
                {
                    self.bestMatches.append(SearchSuggestion(name: street))
                }
            }
            
            print("Avenues retrieved:\n")
            for case let item:SearchSuggestion in self.bestMatches
            {
                print("Avenue: \(item.name)")
            }
            
            // The amount of listed avenues is 32 (Thirty two)
            XCTAssert(self.bestMatches.count > 0)
            XCTAssertEqual(self.bestMatches.count, 32)
            
            self.bestMatches.removeAll()
            
            avenuesExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1)
        { error in
            
            if let error = error
            {
                print("A second (1) timeout ocurred waiting on all avenues names with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
    
    func testResultContentsForDiagonalsSearch()
    {
        searchText = "Diag "
        
        let diagonalsExpectation = expectationWithDescription("GISServiceGatherAllDiagonalsNames")
        
        mgpGISService.getStreetNamesByFile(forName: searchText)
        { (streets, error) in
            if let streets = streets
            {
                for street in streets
                {
                    self.bestMatches.append(SearchSuggestion(name: street))
                }
            }
            
            print("Diagonals retrieved:\n")
            for case let item:SearchSuggestion in self.bestMatches
            {
                print("Diagonal: \(item.name)")
            }
            
            // The amount of listed avenues is 9 (Nine)
            XCTAssert(self.bestMatches.count > 0)
            XCTAssertEqual(self.bestMatches.count, 9)
            
            self.bestMatches.removeAll()
            
            diagonalsExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1)
        { error in
            
            if let error = error
            {
                print("A second (1) timeout ocurred waiting on all diagonals names with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
    
    func testResultContentsForAllStreetsSearch()
    {
        let allStreetsExpectation = expectationWithDescription("GISServiceGatherAllStreetsNames")
        
        mgpGISService.getAllStreetNamesByFile()
            { (streets, error) in
                if let streets = streets
                {
                    for street in streets
                    {
                        self.bestMatches.append(SearchSuggestion(name: street))
                    }
                }
                
                print("Street retrieved: \(self.bestMatches.count)\n")
                for case let item:SearchSuggestion in self.bestMatches
                {
                    print("Street: \(item.name)")
                }
                
                // The amount of listed avenues is 596 (Five hundred ninety six)
                XCTAssert(self.bestMatches.count > 0)
                XCTAssertEqual(self.bestMatches.count, 596)
                
                self.bestMatches.removeAll()
                
                allStreetsExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5)
        { error in
            
            if let error = error
            {
                print("A 5 (Five) seconds timeout ocurred waiting on all streets names with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
    
    func testResultContentsForAddressFromCoordinate()
    {
        let addressFromCoordinateExpectation = expectationWithDescription("GISServiceGatherAddressForCoordinate")
        
        // Spark Digital's Mar del Plata Office LAT/LON coordinates
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -38.019984, longitude: -57.545083)
        
        mgpGISService.getAddressFromCoordinate(coordinate.latitude, longitude: coordinate.longitude, completionHandler: { (routePoint, error) in
            
            if let point = routePoint
            {
                // The amount of listed avenues is 596 (Five hundred ninety six)
                XCTAssertNotNil(point)
                XCTAssertNotNil(point.stopId)
                XCTAssertNotNil(point.name)
                XCTAssertNotNil(point.address)
                XCTAssertNotNil(point.latitude)
                XCTAssertNotNil(point.longitude)
                
                XCTAssertEqual(point.latitude, coordinate.latitude)
                XCTAssertEqual(point.longitude, coordinate.longitude)
                
                print("\nAddress: \(point.address) from coordinate (LAT:\(point.latitude),LON:\(point.longitude))")
            }
            
            addressFromCoordinateExpectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(10)
        { error in
            
            if let error = error
            {
                print("A 10 (Ten) seconds timeout ocurred waiting on address from coordinate with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
}
