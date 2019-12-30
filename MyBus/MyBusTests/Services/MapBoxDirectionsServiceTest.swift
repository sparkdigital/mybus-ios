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
@testable import MYBUS

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
        let walkingDirectionsExpectation = expectation(description: "MapBoxDirectionsServiceGatherWalkingDirections")
        
        // Avenida Pedro Luro and Avenida Independencia
        // To
        // Avenida Colón and Buenos Aires
        
        let originLocationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.9962268, longitude: -57.5535847)
        let destinationLocationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -38.005980, longitude: -57.545158)
        
        directionsService.getWalkingDirections(originLocationCoordinate, destinationCoordinate: destinationLocationCoordinate, completionHandler: { (route, waypoints, error) in
            
            if let walkingDirection = route, let waypoints = waypoints
            {
                let source: Waypoint = waypoints.first!
                let destination: Waypoint = waypoints.last!
                let waypoints: [Waypoint] = waypoints
                let route: MapboxDirections.Route = walkingDirection
                
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
                
                for case let item:Waypoint in waypoints
                {
                    XCTAssertNotNil(item)
                    
                    XCTAssertNotNil(item.name)
                    XCTAssertNotNil(item.coordinate)
                    XCTAssertNotNil(item.coordinate.latitude)
                    XCTAssertNotNil(item.coordinate.longitude)
                }
                
                let item:MapboxDirections.Route = route
                
                XCTAssertNotNil(item)
                
                XCTAssertNotNil(item.legs)
                for case let subItem:RouteLeg in item.legs
                {
                    XCTAssertNotNil(subItem.steps)
                    for case let underSubItem:RouteStep in subItem.steps
                    {
                        XCTAssertNotNil(underSubItem.transportType)
                        XCTAssertNotNil(underSubItem.maneuverType)
                        XCTAssertNotNil(underSubItem.instructions)
                        XCTAssertNotNil(underSubItem.distance)
                        XCTAssertNotNil(underSubItem.coordinates)
                        
                        for case let ultimateItem:CLLocationCoordinate2D in underSubItem.coordinates!
                        {
                            XCTAssertNotNil(ultimateItem.latitude)
                            XCTAssertNotNil(ultimateItem.longitude)
                        }
                        
                        XCTAssertNotNil(underSubItem.expectedTravelTime)
                        XCTAssertNotNil(underSubItem.names)
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
                    XCTAssertNotNil(subItem.profileIdentifier)
                    XCTAssertNotNil(subItem.source)
                    XCTAssertNotNil(subItem.destination)
                }
                
                XCTAssertNotNil(item.distance)
                XCTAssertGreaterThanOrEqual(item.distance, 0.0)
                XCTAssertNotNil(item.expectedTravelTime)
                XCTAssertGreaterThanOrEqual(item.expectedTravelTime, 0.0)
                XCTAssertNotNil(item.routeIdentifier)
                
                XCTAssertNotNil(item.coordinates)
                for case let subItem:CLLocationCoordinate2D in item.coordinates!
                {
                    XCTAssertNotNil(subItem.latitude)
                    XCTAssertNotNil(subItem.longitude)
                }
                
                XCTAssertNotNil(waypoints)
                for case let subItem:Waypoint in waypoints
                {
                    XCTAssertNotNil(subItem.name)
                    XCTAssertNotNil(subItem.coordinate)
                    XCTAssertNotNil(subItem.coordinate.latitude)
                    XCTAssertNotNil(subItem.coordinate.longitude)
                }
            }
            
            walkingDirectionsExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 30)
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
        
        self.measure
            {
                self.directionsService.getWalkingDirections(originLocationCoordinate, destinationCoordinate: destinationLocationCoordinate, completionHandler: { (route, waypoints, error) in
                    
                    if let walkingDirection = route, let waypoints = waypoints
                    {
                        let source: Waypoint = waypoints.first!
                        let destination: Waypoint = waypoints.last!
                        let waypoints: [Waypoint] = waypoints
                        let route: MapboxDirections.Route = walkingDirection
                        
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
                        
                        for case let item:Waypoint in waypoints
                        {
                            XCTAssertNotNil(item)
                            
                            XCTAssertNotNil(item.name)
                            XCTAssertNotNil(item.coordinate)
                            XCTAssertNotNil(item.coordinate.latitude)
                            XCTAssertNotNil(item.coordinate.longitude)
                        }
                        
                        let item = route
                        XCTAssertNotNil(item)
                        
                        XCTAssertNotNil(item.legs)
                        for case let subItem:RouteLeg in item.legs
                        {
                            XCTAssertNotNil(subItem.steps)
                            for case let underSubItem:RouteStep in subItem.steps
                            {
                                XCTAssertNotNil(underSubItem.transportType)
                                XCTAssertNotNil(underSubItem.maneuverType)
                                XCTAssertNotNil(underSubItem.instructions)
                                XCTAssertNotNil(underSubItem.distance)
                                
                                XCTAssertNotNil(underSubItem.coordinates)
                                for case let ultimateItem:CLLocationCoordinate2D in underSubItem.coordinates!
                                {
                                    XCTAssertNotNil(ultimateItem.latitude)
                                    XCTAssertNotNil(ultimateItem.longitude)
                                }
                                
                                XCTAssertNotNil(underSubItem.expectedTravelTime)
                                XCTAssertNotNil(underSubItem.names)
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
                            XCTAssertNotNil(subItem.profileIdentifier)
                            XCTAssertNotNil(subItem.source)
                            XCTAssertNotNil(subItem.destination)
                        }
                        
                        XCTAssertNotNil(item.distance)
                        XCTAssertGreaterThanOrEqual(item.distance, 0.0)
                        XCTAssertNotNil(item.expectedTravelTime)
                        XCTAssertGreaterThanOrEqual(item.expectedTravelTime, 0.0)
                        XCTAssertNotNil(item.routeIdentifier)
                        
                        XCTAssertNotNil(item.coordinates)
                        for case let subItem:CLLocationCoordinate2D in item.coordinates!
                        {
                            XCTAssertNotNil(subItem.latitude)
                            XCTAssertNotNil(subItem.longitude)
                        }
                        
                        XCTAssertNotNil(waypoints)
                        for case let subItem:Waypoint in waypoints
                        {
                            XCTAssertNotNil(subItem.name)
                            XCTAssertNotNil(subItem.coordinate)
                            XCTAssertNotNil(subItem.coordinate.latitude)
                            XCTAssertNotNil(subItem.coordinate.longitude)
                        }
                    }
                })
        }
    }
}
