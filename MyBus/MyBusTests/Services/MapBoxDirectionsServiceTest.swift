//
//  MapBoxDirectionsServiceTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/24/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import MapKit
import MapboxDirections

class MapBoxDirectionsServiceTest: XCTestCase
{
    let directionsService:MapBoxDirectionsService = MapBoxDirectionsService()
    
    override func setUp()
    {
        super.setUp()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testResultContentsForWalkingDirections()
    {
        let walkingDirectionsExpectation = expectationWithDescription("MapBoxDirectionsServiceGatherWalkingDirections")
        
        // Avenida Pedro Luro and Avenida Independencia
        // To
        // Avenida Colón and Buenos Aires
        
        let originLocationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.9962268, longitude: -57.5535847)
        let destinationLocationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -38.005980, longitude: -57.545158)
        
        directionsService.getWalkingDirections(originLocationCoordinate, destinationCoordinate: destinationLocationCoordinate, completionHandler: { (directionResponse, error) in
            
            if let walkingDirection = directionResponse
            {
                let source: MBPoint = walkingDirection.source
                let destination: MBPoint = walkingDirection.destination
                let waypoints: [MBPoint] = walkingDirection.waypoints
                let routes: [MBRoute] = walkingDirection.routes
                
                XCTAssertNotNil(source)
                XCTAssertNotNil(source.name)
                XCTAssertNotNil(source.coordinate)
                XCTAssertNotNil(source.coordinate.latitude)
                XCTAssertNotNil(source.coordinate.longitude)
                
                XCTAssertNotNil(destination)
                XCTAssertNotNil(destination.name)
                XCTAssertNotNil(destination.coordinate)
                XCTAssertNotNil(destination.coordinate.latitude)
                XCTAssertNotNil(destination.coordinate.longitude)
                
                for case let item:MBPoint in waypoints
                {
                    XCTAssertNotNil(item)
                    
                    XCTAssertNotNil(item.name)
                    XCTAssertNotNil(item.coordinate)
                    XCTAssertNotNil(item.coordinate.latitude)
                    XCTAssertNotNil(item.coordinate.longitude)
                }
                
                for case let item:MBRoute in routes
                {
                    XCTAssertNotNil(item)
                    
                    XCTAssertNotNil(item.legs)
                    for case let subItem:MBRouteLeg in item.legs
                    {
                        XCTAssertNotNil(subItem.steps)
                        for case let underSubItem:MBRouteStep in subItem.steps
                        {
                            XCTAssertNotNil(underSubItem.transportType)
                            XCTAssertNotNil(underSubItem.maneuverType)
                            XCTAssertNotNil(underSubItem.instructions)
                            XCTAssertNotNil(underSubItem.distance)
                            XCTAssertNotNil(underSubItem.profileIdentifier)
                            
                            XCTAssertNotNil(underSubItem.geometry)
                            for case let ultimateItem:CLLocationCoordinate2D in underSubItem.geometry!
                            {
                                XCTAssertNotNil(ultimateItem.latitude)
                                XCTAssertNotNil(ultimateItem.longitude)
                            }
                            
                            XCTAssertNotNil(underSubItem.duration)
                            XCTAssertNotNil(underSubItem.name)
                            XCTAssertNotNil(underSubItem.initialHeading)
                            XCTAssertNotNil(underSubItem.finalHeading)
                            XCTAssertNotNil(underSubItem.maneuverLocation)
                            XCTAssertNotNil(underSubItem.maneuverLocation.latitude)
                            XCTAssertNotNil(underSubItem.maneuverLocation.longitude)
                        }
                        
                        XCTAssertNotNil(subItem.name)
                        XCTAssertNotNil(subItem.distance)
                        XCTAssertNotNil(subItem.expectedTravelTime)
                        XCTAssertGreaterThanOrEqual(subItem.expectedTravelTime, 0.0)
                        XCTAssertNotNil(subItem.transportType)
                        XCTAssertNotNil(subItem.profileIdentifier)
                        XCTAssertNotNil(subItem.source)
                        XCTAssertNotNil(subItem.destination)
                    }
                    
                    XCTAssertNotNil(item.distance)
                    XCTAssertGreaterThanOrEqual(item.distance, 0.0)
                    XCTAssertNotNil(item.expectedTravelTime)
                    XCTAssertGreaterThanOrEqual(item.expectedTravelTime, 0.0)
                    XCTAssertNotNil(item.transportType)
                    XCTAssertNotNil(item.profileIdentifier)
                    
                    XCTAssertNotNil(item.geometry)
                    for case let subItem:CLLocationCoordinate2D in item.geometry
                    {
                        XCTAssertNotNil(subItem.latitude)
                        XCTAssertNotNil(subItem.longitude)
                    }
                    
                    XCTAssertNotNil(item.source)
                    XCTAssertNotNil(item.destination)
                    
                    XCTAssertNotNil(item.waypoints)
                    for case let subItem:MBPoint in item.waypoints
                    {
                        XCTAssertNotNil(subItem.name)
                        XCTAssertNotNil(subItem.coordinate)
                        XCTAssertNotNil(subItem.coordinate.latitude)
                        XCTAssertNotNil(subItem.coordinate.longitude)
                    }
                }
            }
            
            walkingDirectionsExpectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(30)
        { error in
            
            if let error = error
            {
                print("A 30 (Thirty) seconds timeout ocurred waiting on walking directions with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
    
    func testPerformanceForWalkingDirections()
    {
        // Avenida Pedro Luro and Avenida Independencia
        // To
        // Avenida Colón and Buenos Aires
        
        let originLocationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.9962268, longitude: -57.5535847)
        let destinationLocationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -38.005980, longitude: -57.545158)
        
        self.measureBlock
            {
                self.directionsService.getWalkingDirections(originLocationCoordinate, destinationCoordinate: destinationLocationCoordinate, completionHandler: { (directionResponse, error) in
                    
                    if let walkingDirection = directionResponse
                    {
                        let source: MBPoint = walkingDirection.source
                        let destination: MBPoint = walkingDirection.destination
                        let waypoints: [MBPoint] = walkingDirection.waypoints
                        let routes: [MBRoute] = walkingDirection.routes
                        
                        XCTAssertNotNil(source)
                        XCTAssertNotNil(source.name)
                        XCTAssertNotNil(source.coordinate)
                        XCTAssertNotNil(source.coordinate.latitude)
                        XCTAssertNotNil(source.coordinate.longitude)
                        
                        XCTAssertNotNil(destination)
                        XCTAssertNotNil(destination.name)
                        XCTAssertNotNil(destination.coordinate)
                        XCTAssertNotNil(destination.coordinate.latitude)
                        XCTAssertNotNil(destination.coordinate.longitude)
                        
                        for case let item:MBPoint in waypoints
                        {
                            XCTAssertNotNil(item)
                            
                            XCTAssertNotNil(item.name)
                            XCTAssertNotNil(item.coordinate)
                            XCTAssertNotNil(item.coordinate.latitude)
                            XCTAssertNotNil(item.coordinate.longitude)
                        }
                        
                        for case let item:MBRoute in routes
                        {
                            XCTAssertNotNil(item)
                            
                            XCTAssertNotNil(item.legs)
                            for case let subItem:MBRouteLeg in item.legs
                            {
                                XCTAssertNotNil(subItem.steps)
                                for case let underSubItem:MBRouteStep in subItem.steps
                                {
                                    XCTAssertNotNil(underSubItem.transportType)
                                    XCTAssertNotNil(underSubItem.maneuverType)
                                    XCTAssertNotNil(underSubItem.instructions)
                                    XCTAssertNotNil(underSubItem.distance)
                                    XCTAssertNotNil(underSubItem.profileIdentifier)
                                    
                                    XCTAssertNotNil(underSubItem.geometry)
                                    for case let ultimateItem:CLLocationCoordinate2D in underSubItem.geometry!
                                    {
                                        XCTAssertNotNil(ultimateItem.latitude)
                                        XCTAssertNotNil(ultimateItem.longitude)
                                    }
                                    
                                    XCTAssertNotNil(underSubItem.duration)
                                    XCTAssertNotNil(underSubItem.name)
                                    XCTAssertNotNil(underSubItem.initialHeading)
                                    XCTAssertNotNil(underSubItem.finalHeading)
                                    XCTAssertNotNil(underSubItem.maneuverLocation)
                                    XCTAssertNotNil(underSubItem.maneuverLocation.latitude)
                                    XCTAssertNotNil(underSubItem.maneuverLocation.longitude)
                                }
                                
                                XCTAssertNotNil(subItem.name)
                                XCTAssertNotNil(subItem.distance)
                                XCTAssertNotNil(subItem.expectedTravelTime)
                                XCTAssertGreaterThanOrEqual(subItem.expectedTravelTime, 0.0)
                                XCTAssertNotNil(subItem.transportType)
                                XCTAssertNotNil(subItem.profileIdentifier)
                                XCTAssertNotNil(subItem.source)
                                XCTAssertNotNil(subItem.destination)
                            }
                            
                            XCTAssertNotNil(item.distance)
                            XCTAssertGreaterThanOrEqual(item.distance, 0.0)
                            XCTAssertNotNil(item.expectedTravelTime)
                            XCTAssertGreaterThanOrEqual(item.expectedTravelTime, 0.0)
                            XCTAssertNotNil(item.transportType)
                            XCTAssertNotNil(item.profileIdentifier)
                            
                            XCTAssertNotNil(item.geometry)
                            for case let subItem:CLLocationCoordinate2D in item.geometry
                            {
                                XCTAssertNotNil(subItem.latitude)
                                XCTAssertNotNil(subItem.longitude)
                            }
                            
                            XCTAssertNotNil(item.source)
                            XCTAssertNotNil(item.destination)
                            
                            XCTAssertNotNil(item.waypoints)
                            for case let subItem:MBPoint in item.waypoints
                            {
                                XCTAssertNotNil(subItem.name)
                                XCTAssertNotNil(subItem.coordinate)
                                XCTAssertNotNil(subItem.coordinate.latitude)
                                XCTAssertNotNil(subItem.coordinate.longitude)
                            }
                        }
                    }
                })
        }
    }
}
