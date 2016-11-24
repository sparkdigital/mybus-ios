//
//  ConnectivityTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/24/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import MapKit

class ConnectivityTest: XCTestCase
{
    let connectivityService = Connectivity.sharedInstance
    
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
    
    func testResultExistence()
    {
        XCTAssertNotNil(connectivityService)
    }
    
    func testResultUniqueness()
    {
        XCTAssertEqual(connectivityService, Connectivity.sharedInstance)
    }
    
    func testResultContentsForAvenuesSearch()
    {
        searchText = "Av "
        
        let avenuesExpectation = expectationWithDescription("GatherAllAvenuesNames")
        
        Connectivity.sharedInstance.getStreetNames(forName: searchText)
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
        
        let diagonalsExpectation = expectationWithDescription("GatherAllDiagonalsNames")
        
        Connectivity.sharedInstance.getStreetNames(forName: searchText)
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
        let allStreetsExpectation = expectationWithDescription("GatherAllStreetsNames")
        
        Connectivity.sharedInstance.getAllStreetNames()
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
                print("A 5 (five) seconds timeout ocurred waiting on all streets names with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
    
    func testResultContentsForAddressFromCoordinate()
    {
        let addressFromCoordinateExpectation = expectationWithDescription("GatherAddressForCoordinate")
        
        // Spark Digital's Mar del Plata Office LAT/LON coordinates
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -38.019984, longitude: -57.545083)
        
        Connectivity.sharedInstance.getAddressFromCoordinate(coordinate.latitude, longitude: coordinate.longitude, completionHandler: { (routePoint, error) in
            
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
                print("A 10 (ten) seconds timeout ocurred waiting on address from coordinate with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
    
    func testResultContentsForCoordinateFromAddress()
    {
        let coordinateFromAddressExpectation = expectationWithDescription("GatherCoordinateFromAddress")
        
        // El Gaucho Monument's LAT/LON coordinates
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.999347899999997, longitude: -57.596915499999987)
        let address = "Av. Juan B. Justo 6200"
        
        Connectivity.sharedInstance.getCoordinateFromAddress(address, completionHandler: { (routePoint, error) in
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
        
        waitForExpectationsWithTimeout(10)
        { error in
            
            if let error = error
            {
                print("A 10 (ten) seconds timeout ocurred waiting on coordinate from address with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
    
    func testResultContentsForBusLinesFromOriginDestinationSingle()
    {
        let busLinesFromOriginDestinationSingleExpectation = expectationWithDescription("GatherBusLinesFromOriginDestinationSingle")
        
        // El Gaucho Monument's LAT/LON coordinates
        let originCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.999347899999997, longitude: -57.596915499999987)
        
        // Av. Independencia & Av. Pedro Luro LAT/LON coordinates
        let destinationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.995540099999999, longitude: -57.552269300000013)
        
        Connectivity.sharedInstance.getBusLinesFromOriginDestination(originCoordinate.latitude, longitudeOrigin: originCoordinate.longitude, latitudeDestination: destinationCoordinate.latitude, longitudeDestination: destinationCoordinate.longitude) { (busRouteResultArray, error) in
            
            if let busRouteArray = busRouteResultArray
            {
                for case let item:BusRouteResult in busRouteArray
                {
                    XCTAssertNotNil(item)
                    XCTAssert(item.busRoutes.count > 0)
                    XCTAssertNotNil(item.busRouteType)
                    XCTAssertEqual(item.busRouteType, MyBusRouteResultType.Single)
                    
                    let routes = item.busRoutes
                    
                    for case let subItem:BusRoute in routes
                    {
                        XCTAssertNotNil(subItem)
                        
                        XCTAssertGreaterThanOrEqual(subItem.idBusLine!, 0)
                        XCTAssertGreaterThanOrEqual(subItem.busLineDirection, 0)
                        XCTAssertGreaterThanOrEqual(subItem.startBusStopNumber, 0)
                        XCTAssertGreaterThanOrEqual(subItem.startBusStopStreetNumber, 0)
                        XCTAssertGreaterThanOrEqual(subItem.startBusStopDistanceToOrigin, 0.0)
                        XCTAssertGreaterThanOrEqual(subItem.destinationBusStopNumber, 0)
                        XCTAssertGreaterThanOrEqual(subItem.destinationBusStopStreetNumber, 0)
                        XCTAssertGreaterThanOrEqual(subItem.destinationBusStopDistanceToDestination, 0.0)
                        
                        XCTAssertNotNil(subItem.busLineName)
                        XCTAssertNotNil(subItem.busLineColor)
                        XCTAssertNotNil(subItem.startBusStopLat)
                        XCTAssertNotNil(subItem.startBusStopLng)
                        XCTAssertNotNil(subItem.startBusStopStreetName)
                        XCTAssertNotNil(subItem.destinationBusStopLat)
                        XCTAssertNotNil(subItem.destinationBusStopLng)
                        XCTAssertNotNil(subItem.destinationBusStopStreetName)
                        
                        XCTAssertNotEqual(subItem.startBusStopLat, subItem.destinationBusStopLat)
                        XCTAssertNotEqual(subItem.startBusStopLng, subItem.destinationBusStopLng)
                        
                        let busRouteDescription = "Route: Bus \(subItem.busLineName) from \(subItem.startBusStopStreetName) \(subItem.startBusStopStreetNumber) to \(subItem.destinationBusStopStreetName) \(subItem.destinationBusStopStreetNumber)\n"
                        
                        print(busRouteDescription)
                    }
                    
                    let busRouteDescription = "BusRouteResult with Type:\(item.busRouteType) and CombinationDistance:\(item.combinationDistance)\n"
                    
                    print(busRouteDescription)
                }
            }
            
            busLinesFromOriginDestinationSingleExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10)
        { error in
            
            if let error = error
            {
                print("A 10 (ten) seconds timeout ocurred waiting on BusLines for origin-destination(Single) with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
    
    func testResultContentsForBusLinesFromOriginDestinationCombined()
    {
        let busLinesFromOriginDestinationCombinedExpectation = expectationWithDescription("GatherBusLinesFromOriginDestinationCombined")
        
        // El Gaucho Monument's LAT/LON coordinates
        let originCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.999347899999997, longitude: -57.596915499999987)
        
        // Luzuriaga 301 LAT/LON coordinates
        let destinationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -38.086793900000004, longitude: -57.548919800000007)
        
        Connectivity.sharedInstance.getBusLinesFromOriginDestination(originCoordinate.latitude, longitudeOrigin: originCoordinate.longitude, latitudeDestination: destinationCoordinate.latitude, longitudeDestination: destinationCoordinate.longitude) { (busRouteResultArray, error) in
            
            if let busRouteArray = busRouteResultArray
            {
                for case let item:BusRouteResult in busRouteArray
                {
                    XCTAssertNotNil(item)
                    XCTAssert(item.busRoutes.count > 0)
                    XCTAssertNotNil(item.busRouteType)
                    XCTAssertEqual(item.busRouteType, MyBusRouteResultType.Combined)
                    
                    let routes = item.busRoutes
                    
                    for case let subItem:BusRoute in routes
                    {
                        XCTAssertNotNil(subItem)
                        
                        XCTAssertGreaterThanOrEqual(subItem.idBusLine!, 0)
                        XCTAssertGreaterThanOrEqual(subItem.busLineDirection, 0)
                        XCTAssertGreaterThanOrEqual(subItem.startBusStopNumber, 0)
                        XCTAssertGreaterThanOrEqual(subItem.startBusStopStreetNumber, 0)
                        XCTAssertGreaterThanOrEqual(subItem.startBusStopDistanceToOrigin, 0.0)
                        XCTAssertGreaterThanOrEqual(subItem.destinationBusStopNumber, 0)
                        XCTAssertGreaterThanOrEqual(subItem.destinationBusStopStreetNumber, 0)
                        XCTAssertGreaterThanOrEqual(subItem.destinationBusStopDistanceToDestination, 0.0)
                        
                        XCTAssertNotNil(subItem.busLineName)
                        XCTAssertNotNil(subItem.busLineColor)
                        XCTAssertNotNil(subItem.startBusStopLat)
                        XCTAssertNotNil(subItem.startBusStopLng)
                        XCTAssertNotNil(subItem.startBusStopStreetName)
                        XCTAssertNotNil(subItem.destinationBusStopLat)
                        XCTAssertNotNil(subItem.destinationBusStopLng)
                        XCTAssertNotNil(subItem.destinationBusStopStreetName)
                        
                        XCTAssertNotEqual(subItem.startBusStopLat, subItem.destinationBusStopLat)
                        XCTAssertNotEqual(subItem.startBusStopLng, subItem.destinationBusStopLng)
                        
                        let busRouteDescription = "Route: Bus \(subItem.busLineName) from \(subItem.startBusStopStreetName) \(subItem.startBusStopStreetNumber) to \(subItem.destinationBusStopStreetName) \(subItem.destinationBusStopStreetNumber)\n"
                        
                        print(busRouteDescription)
                    }
                    
                    let busRouteDescription = "BusRouteResult with Type:\(item.busRouteType) and CombinationDistance:\(item.combinationDistance)\n"
                    
                    print(busRouteDescription)
                }
            }
            
            busLinesFromOriginDestinationCombinedExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(30)
        { error in
            
            if let error = error
            {
                print("A 30 (Thirty) seconds timeout ocurred waiting on BusLines for origin-destination(combined) with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
}
