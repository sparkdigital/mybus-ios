//
//  GeoCodingServiceTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/24/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import MapKit
@testable import MYBUS

class GeoCodingServiceTest: XCTestCase
{
    let googleGeocodingService = GeoCodingService()
    
    override func setUp()
    {
        super.setUp()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testResultContentsForCoordinateFromAddress()
    {
        let coordinateFromAddressExpectation = expectation(description: "GeoCodingServiceGatherCoordinateFromAddress")
        
        // El Gaucho Monument's LAT/LON coordinates
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.999347899999997, longitude: -57.596915499999987)
        let address = "Av. Juan B. Justo 6200"
        
        googleGeocodingService.getCoordinateFromAddress(address, completionHandler: { (routePoint, error) in
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
                XCTAssertEqual(point.address, address)
                
                print("\nAddress: \(point.address) from coordinate (LAT:\(point.latitude),LON:\(point.longitude))")
            }
            
            coordinateFromAddressExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 10)
        { error in
            
            if let error = error
            {
                print("A 10 (Ten) seconds timeout ocurred waiting on coordinate from address with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
    
    func testPerformanceForCoordinateFromAddress()
    {
        // El Gaucho Monument's LAT/LON coordinates
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.999347899999997, longitude: -57.596915499999987)
        let address = "Av. Juan B. Justo 6200"
        
        self.measure
            {
                self.googleGeocodingService.getCoordinateFromAddress(address, completionHandler: { (routePoint, error) in
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
                        XCTAssertEqual(point.address, address)
                    }
                })
        }
    }
}
