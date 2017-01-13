//
//  ConnectivityTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/24/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import MapKit
import MapboxDirections
@testable import MyBus

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
    
    // MARK: - Municipality Endpoints
    
    func testResultContentsForAvenuesSearch()
    {
        searchText = "Av "
        
        let avenuesExpectation = expectation(description: "ConnectivityGatherAllAvenuesNames")
        
        connectivityService.getStreetNames(forName: searchText)
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
        
        waitForExpectations(timeout: 1)
        { error in
            
            if let error = error
            {
                print("A second (1) timeout ocurred waiting on all avenues names with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
    
    func testPerformanceForAvenuesSearch()
    {
        searchText = "Av "
        
        self.measureBlock
            {
                self.connectivityService.getStreetNames(forName: self.searchText)
                { (streets, error) in
                    if let streets = streets
                    {
                        for street in streets
                        {
                            self.bestMatches.append(SearchSuggestion(name: street))
                        }
                    }
                    
                    for case let item:SearchSuggestion in self.bestMatches
                    {
                        XCTAssertNotNil(item.name)
                    }
                    
                    // The amount of listed avenues is 32 (Thirty two)
                    XCTAssert(self.bestMatches.count > 0)
                    XCTAssertEqual(self.bestMatches.count, 32)
                    
                    self.bestMatches.removeAll()
                }
        }
    }
    
    func testResultContentsForDiagonalsSearch()
    {
        searchText = "Diag "
        
        let diagonalsExpectation = expectation(description: "ConnectivityGatherAllDiagonalsNames")
        
        connectivityService.getStreetNames(forName: searchText)
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
        
        waitForExpectations(timeout: 1)
        { error in
            
            if let error = error
            {
                print("A second (1) timeout ocurred waiting on all diagonals names with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
    
    func testPerformanceForDiagonalsSearch()
    {
        searchText = "Diag "
        
        self.measureBlock
            {
                self.connectivityService.getStreetNames(forName: self.searchText)
                { (streets, error) in
                    if let streets = streets
                    {
                        for street in streets
                        {
                            self.bestMatches.append(SearchSuggestion(name: street))
                        }
                    }
                    
                    for case let item:SearchSuggestion in self.bestMatches
                    {
                        XCTAssertNotNil(item.name)
                    }
                    
                    // The amount of listed avenues is 9 (Nine)
                    XCTAssert(self.bestMatches.count > 0)
                    XCTAssertEqual(self.bestMatches.count, 9)
                    
                    self.bestMatches.removeAll()
                }
        }
    }
    
    func testResultContentsForAllStreetsSearch()
    {
        let allStreetsExpectation = expectation(description: "ConnectivityGatherAllStreetsNames")
        
        connectivityService.getAllStreetNames()
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
        
        waitForExpectations(timeout: 5)
        { error in
            
            if let error = error
            {
                print("A 5 (Five) seconds timeout ocurred waiting on all streets names with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
    
    func testPerformanceForAllStreetsSearch()
    {
        self.measureBlock
            {
                self.connectivityService.getAllStreetNames()
                    { (streets, error) in
                        if let streets = streets
                        {
                            for street in streets
                            {
                                self.bestMatches.append(SearchSuggestion(name: street))
                            }
                        }
                        
                        for case let item:SearchSuggestion in self.bestMatches
                        {
                            XCTAssertNotNil(item.name)
                        }
                        
                        // The amount of listed avenues is 596 (Five hundred ninety six)
                        XCTAssert(self.bestMatches.count > 0)
                        XCTAssertEqual(self.bestMatches.count, 596)
                        
                        self.bestMatches.removeAll()
                }
        }
    }
    
    func testResultContentsForAddressFromCoordinate()
    {
        let addressFromCoordinateExpectation = expectation(description: "ConnectivityGatherAddressForCoordinate")
        
        // Spark Digital's Mar del Plata Office LAT/LON coordinates
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -38.019984, longitude: -57.545083)
        
        connectivityService.getAddressFromCoordinate(coordinate.latitude, longitude: coordinate.longitude, completionHandler: { (routePoint, error) in
            
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
        
        waitForExpectations(timeout: 10)
        { error in
            
            if let error = error
            {
                print("A 10 (Ten) seconds timeout ocurred waiting on address from coordinate with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
    
    func testPerformanceForAddressFromCoordinate()
    {
        // Spark Digital's Mar del Plata Office LAT/LON coordinates
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -38.019984, longitude: -57.545083)
        
        self.measureBlock
            {
                self.connectivityService.getAddressFromCoordinate(coordinate.latitude, longitude: coordinate.longitude, completionHandler: { (routePoint, error) in
                    
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
                    }
                })
        }
    }
    
    // MARK: - Google Geocoding Endpoint
    
    func testResultContentsForCoordinateFromAddress()
    {
        let coordinateFromAddressExpectation = expectation(description: "ConnectivityGatherCoordinateFromAddress")
        
        // El Gaucho Monument's LAT/LON coordinates
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.999347899999997, longitude: -57.596915499999987)
        let address = "Av. Juan B. Justo 6200"
        let expectedAddress = "Av. Juan B. Justo 6200-6102"
        
        connectivityService.getCoordinateFromAddress(address, completionHandler: { (routePoint, error) in
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
                XCTAssertEqual(point.address, expectedAddress)
                
                print("\nAddress: \(point.address) from coordinate (LAT:\(point.latitude),LON:\(point.longitude))")
            }
            
            coordinateFromAddressExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 60)
        { error in
            
            if let error = error
            {
                print("A 60 (Sixty) seconds timeout ocurred waiting on coordinate from address with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
    
    func testPerformanceForCoordinateFromAddress()
    {
        // El Gaucho Monument's LAT/LON coordinates
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.999347899999997, longitude: -57.596915499999987)
        let address = "Av. Juan B. Justo 6200"
        
        self.measureBlock
            {
                self.connectivityService.getCoordinateFromAddress(address, completionHandler: { (routePoint, error) in
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
    
    // MARK: - MyBus Endpoints
    
    func testResultContentsForBusLinesFromOriginDestinationSingle()
    {
        let busLinesFromOriginDestinationSingleExpectation = expectation(description: "ConnectivityGatherBusLinesFromOriginDestinationSingle")
        
        // El Gaucho Monument's LAT/LON coordinates
        let originCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.999347899999997, longitude: -57.596915499999987)
        
        // Av. Independencia & Av. Pedro Luro LAT/LON coordinates
        let destinationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.995540099999999, longitude: -57.552269300000013)
        
        connectivityService.getBusLinesFromOriginDestination(originCoordinate.latitude, longitudeOrigin: originCoordinate.longitude, latitudeDestination: destinationCoordinate.latitude, longitudeDestination: destinationCoordinate.longitude) { (busRouteResultArray, error) in
            
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
        
        waitForExpectations(timeout: 90)
        { error in
            
            if let error = error
            {
                print("A 90 (Ninety) seconds timeout ocurred waiting on BusLines for origin-destination(Single) with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
    
    func testPerformanceForBusLinesFromOriginDestinationSingle()
    {
        // El Gaucho Monument's LAT/LON coordinates
        let originCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.999347899999997, longitude: -57.596915499999987)
        
        // Av. Independencia & Av. Pedro Luro LAT/LON coordinates
        let destinationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.995540099999999, longitude: -57.552269300000013)
        
        self.measureBlock
            {
                self.connectivityService.getBusLinesFromOriginDestination(originCoordinate.latitude, longitudeOrigin: originCoordinate.longitude, latitudeDestination: destinationCoordinate.latitude, longitudeDestination: destinationCoordinate.longitude) { (busRouteResultArray, error) in
                    
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
                            }
                        }
                    }
                }
        }
    }
    
    func testResultContentsForBusLinesFromOriginDestinationCombined()
    {
        let busLinesFromOriginDestinationCombinedExpectation = expectation(description: "ConnectivityGatherBusLinesFromOriginDestinationCombined")
        
        // El Gaucho Monument's LAT/LON coordinates
        let originCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.999347899999997, longitude: -57.596915499999987)
        
        // Luzuriaga 301 LAT/LON coordinates
        let destinationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -38.086793900000004, longitude: -57.548919800000007)
        
        connectivityService.getBusLinesFromOriginDestination(originCoordinate.latitude, longitudeOrigin: originCoordinate.longitude, latitudeDestination: destinationCoordinate.latitude, longitudeDestination: destinationCoordinate.longitude) { (busRouteResultArray, error) in
            
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
        
        waitForExpectations(timeout: 120)
        { error in
            
            if let error = error
            {
                print("A 120 (Hundred and twenty) seconds timeout ocurred waiting on BusLines for origin-destination(combined) with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
    
    func testPerformanceForBusLinesFromOriginDestinationCombined()
    {
        // El Gaucho Monument's LAT/LON coordinates
        let originCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.999347899999997, longitude: -57.596915499999987)
        
        // Luzuriaga 301 LAT/LON coordinates
        let destinationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -38.086793900000004, longitude: -57.548919800000007)
        
        self.measureBlock
            {
                self.connectivityService.getBusLinesFromOriginDestination(originCoordinate.latitude, longitudeOrigin: originCoordinate.longitude, latitudeDestination: destinationCoordinate.latitude, longitudeDestination: destinationCoordinate.longitude) { (busRouteResultArray, error) in
                    
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
                            }
                        }
                    }
                }
        }
    }
    
    func testResultContentsForSingleRoadResult()
    {
        let singleRoadResultExpectation = expectation(description: "ConnectivityGatherSingleRoadResult")
        
        // Bus 522 | From Origin: "Rosales 3458" to Destination: "Brasil 316"
        let busIDLine:Int = 9
        let direction:Int = 1
        let beginStopLine:Int = 50
        let endStopLine:Int = 158
        
        connectivityService.getSingleResultRoadApi(busIDLine, firstDirection: direction, beginStopFirstLine: beginStopLine, endStopFirstLine: endStopLine) { (roadResult, error) in
            
            if let singleRoadResult = roadResult
            {
                XCTAssertNotNil(singleRoadResult.roadResultType)
                XCTAssertNotNil(singleRoadResult.totalDistances)
                XCTAssertNotNil(singleRoadResult.travelTime)
                XCTAssertNotNil(singleRoadResult.arrivalTime)
                XCTAssertNotNil(singleRoadResult.idBusLine1)
                XCTAssertNotNil(singleRoadResult.idBusLine2)
                
                XCTAssert(singleRoadResult.routeList.count > 0)
                XCTAssert(singleRoadResult.getPointList().count > 0)
                
                switch singleRoadResult.busRouteResultType()
                {
                case .Single:
                    XCTAssertNotNil(singleRoadResult.firstBusStop)
                    XCTAssertNotNil(singleRoadResult.endBusStop)
                case .Combined:
                    XCTAssertNotNil(singleRoadResult.midStartStop)
                    XCTAssertNotNil(singleRoadResult.midEndStop)
                }
                
                XCTAssertNotEqual(singleRoadResult.firstBusStop?.latitude, singleRoadResult.midEndStop?.latitude)
                XCTAssertNotEqual(singleRoadResult.firstBusStop?.longitude, singleRoadResult.midEndStop?.longitude)
                
                for case let item:RoutePoint in singleRoadResult.getPointList()
                {
                    XCTAssertNotNil(item.stopId)
                    XCTAssertNotNil(item.latitude)
                    XCTAssertNotNil(item.longitude)
                    XCTAssertNotNil(item.address)
                    XCTAssertNotNil(item.isWaypoint)
                    XCTAssertNotNil(item.name)
                }
            }
            
            singleRoadResultExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 60)
        { error in
            
            if let error = error
            {
                print("A 60 (Sixty) seconds timeout ocurred waiting on single RoadResult with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
    
    func testPerformanceForSingleRoadResult()
    {
        // Bus 522 | From Origin: "Rosales 3458" to Destination: "Brasil 316"
        let busIDLine:Int = 9
        let direction:Int = 1
        let beginStopLine:Int = 50
        let endStopLine:Int = 158
        
        self.measureBlock
            {
                self.connectivityService.getSingleResultRoadApi(busIDLine, firstDirection: direction, beginStopFirstLine: beginStopLine, endStopFirstLine: endStopLine) { (roadResult, error) in
                    
                    if let singleRoadResult = roadResult
                    {
                        XCTAssertNotNil(singleRoadResult.roadResultType)
                        XCTAssertNotNil(singleRoadResult.totalDistances)
                        XCTAssertNotNil(singleRoadResult.travelTime)
                        XCTAssertNotNil(singleRoadResult.arrivalTime)
                        XCTAssertNotNil(singleRoadResult.idBusLine1)
                        XCTAssertNotNil(singleRoadResult.idBusLine2)
                        
                        XCTAssert(singleRoadResult.routeList.count > 0)
                        XCTAssert(singleRoadResult.getPointList().count > 0)
                        
                        switch singleRoadResult.busRouteResultType()
                        {
                        case .Single:
                            XCTAssertNotNil(singleRoadResult.firstBusStop)
                            XCTAssertNotNil(singleRoadResult.endBusStop)
                        case .Combined:
                            XCTAssertNotNil(singleRoadResult.midStartStop)
                            XCTAssertNotNil(singleRoadResult.midEndStop)
                        }
                        
                        XCTAssertNotEqual(singleRoadResult.firstBusStop?.latitude, singleRoadResult.midEndStop?.latitude)
                        XCTAssertNotEqual(singleRoadResult.firstBusStop?.longitude, singleRoadResult.midEndStop?.longitude)
                        
                        for case let item:RoutePoint in singleRoadResult.getPointList()
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
        }
    }
    
    func testResultContentsForCombinedRoadResult()
    {
        let combinedRoadResultExpectation = expectation(description: "ConnectivityGatherCombinedRoadResult")

        // Buses 531 -> 511b | From Origin: "Luzuriaga 301" to Destination: "Velez Sarfield 257"
        let firstBusIDLine:Int = 11
        let firstDirection:Int = 0
        let firstBeginStopLine:Int = 11
        let firstEndStopLine:Int = 27
        
        let secondBusIDLine:Int = 28
        let secondDirection:Int = 0
        let secondBeginStopLine:Int = 38
        let secondEndStopLine:Int = 131
        
        connectivityService.getCombinedResultRoadApi(firstBusIDLine, idSecondLine: secondBusIDLine, firstDirection: firstDirection, secondDirection: secondDirection, beginStopFirstLine: firstBeginStopLine, endStopFirstLine: firstEndStopLine, beginStopSecondLine: secondBeginStopLine, endStopSecondLine: secondEndStopLine)
        { (roadResult, error) in
            
            if let combinedRoadResult = roadResult
            {
                XCTAssertNotNil(combinedRoadResult.roadResultType)
                XCTAssertNotNil(combinedRoadResult.totalDistances)
                XCTAssertNotNil(combinedRoadResult.travelTime)
                XCTAssertNotNil(combinedRoadResult.arrivalTime)
                XCTAssertNotNil(combinedRoadResult.idBusLine1)
                XCTAssertNotNil(combinedRoadResult.idBusLine2)
                
                XCTAssert(combinedRoadResult.routeList.count > 0)
                XCTAssert(combinedRoadResult.getPointList().count > 0)
                
                switch combinedRoadResult.busRouteResultType()
                {
                case .Single:
                    XCTAssertNotNil(combinedRoadResult.firstBusStop)
                    XCTAssertNotNil(combinedRoadResult.endBusStop)
                case .Combined:
                    XCTAssertNotNil(combinedRoadResult.midStartStop)
                    XCTAssertNotNil(combinedRoadResult.midEndStop)
                }
                
                XCTAssertNotEqual(combinedRoadResult.firstBusStop?.latitude, combinedRoadResult.midEndStop?.latitude)
                XCTAssertNotEqual(combinedRoadResult.firstBusStop?.longitude, combinedRoadResult.midEndStop?.longitude)
                
                for case let item:RoutePoint in combinedRoadResult.getPointList()
                {
                    XCTAssertNotNil(item.stopId)
                    XCTAssertNotNil(item.latitude)
                    XCTAssertNotNil(item.longitude)
                    XCTAssertNotNil(item.address)
                    XCTAssertNotNil(item.isWaypoint)
                    XCTAssertNotNil(item.name)
                }
            }
            
            combinedRoadResultExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 90)
        { error in
            
            if let error = error
            {
                print("A 90 (Ninety) seconds timeout ocurred waiting on combined RoadResult with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
    
    func testPerformanceForCombinedRoadResult()
    {
        // Buses 531 -> 511b | From Origin: "Luzuriaga 301" to Destination: "Velez Sarfield 257"
        let firstBusIDLine:Int = 11
        let firstDirection:Int = 0
        let firstBeginStopLine:Int = 11
        let firstEndStopLine:Int = 27
        
        let secondBusIDLine:Int = 28
        let secondDirection:Int = 0
        let secondBeginStopLine:Int = 38
        let secondEndStopLine:Int = 131
        
        self.measureBlock
            {
                self.connectivityService.getCombinedResultRoadApi(firstBusIDLine, idSecondLine: secondBusIDLine, firstDirection: firstDirection, secondDirection: secondDirection, beginStopFirstLine: firstBeginStopLine, endStopFirstLine: firstEndStopLine, beginStopSecondLine: secondBeginStopLine, endStopSecondLine: secondEndStopLine)
                { (roadResult, error) in
                    
                    if let combinedRoadResult = roadResult
                    {
                        XCTAssertNotNil(combinedRoadResult.roadResultType)
                        XCTAssertNotNil(combinedRoadResult.totalDistances)
                        XCTAssertNotNil(combinedRoadResult.travelTime)
                        XCTAssertNotNil(combinedRoadResult.arrivalTime)
                        XCTAssertNotNil(combinedRoadResult.idBusLine1)
                        XCTAssertNotNil(combinedRoadResult.idBusLine2)
                        
                        XCTAssert(combinedRoadResult.routeList.count > 0)
                        XCTAssert(combinedRoadResult.getPointList().count > 0)
                        
                        switch combinedRoadResult.busRouteResultType()
                        {
                        case .Single:
                            XCTAssertNotNil(combinedRoadResult.firstBusStop)
                            XCTAssertNotNil(combinedRoadResult.endBusStop)
                        case .Combined:
                            XCTAssertNotNil(combinedRoadResult.midStartStop)
                            XCTAssertNotNil(combinedRoadResult.midEndStop)
                        }
                        
                        XCTAssertNotEqual(combinedRoadResult.firstBusStop?.latitude, combinedRoadResult.midEndStop?.latitude)
                        XCTAssertNotEqual(combinedRoadResult.firstBusStop?.longitude, combinedRoadResult.midEndStop?.longitude)
                        
                        for case let item:RoutePoint in combinedRoadResult.getPointList()
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
        }
    }
    
    func testResultContentsForCompleteBusRoute531()
    {
        let completeBusRoute531Expectation = expectation(description: "ConnectivityGatherCompleteBusRouteFor531")
        
        // Bus 531
        let busLineID:Int = 11
        let goingDirection:Int = 0
        let returningDirection:Int = 1
        let busLineName:String = "531"
        
        let connectivtyResultsCompletionHandler: (CompleteBusRoute?, NSError?) -> Void = { (justGoingBusRoute, error) in
            if let completeRoute = justGoingBusRoute
            {
                //Get route in returning way
                self.connectivityService.getCompleteRoads(busLineID, direction: returningDirection, completionHandler: { (returnBusRoute, error) in
                    
                    completeRoute.busLineName = busLineName
                    
                    if let fullCompleteRoute = returnBusRoute
                    {
                        //Another hack
                        completeRoute.returnPointList = fullCompleteRoute.goingPointList
                    }
                    
                    XCTAssert(completeRoute.goingPointList.count > 0)
                    XCTAssert(completeRoute.returnPointList.count > 0)
                    
                    XCTAssertFalse(completeRoute.isEqualStartGoingEndReturn())
                    XCTAssertFalse(completeRoute.isEqualStartReturnEndGoing())
                    
                    for case let item:RoutePoint in completeRoute.goingPointList
                    {
                        XCTAssertNotNil(item.stopId)
                        XCTAssertNotNil(item.latitude)
                        XCTAssertNotNil(item.longitude)
                        XCTAssertNotNil(item.address)
                        XCTAssertNotNil(item.isWaypoint)
                        XCTAssertNotNil(item.name)
                    }
                    
                    for case let item:RoutePoint in completeRoute.returnPointList
                    {
                        XCTAssertNotNil(item.stopId)
                        XCTAssertNotNil(item.latitude)
                        XCTAssertNotNil(item.longitude)
                        XCTAssertNotNil(item.address)
                        XCTAssertNotNil(item.isWaypoint)
                        XCTAssertNotNil(item.name)
                    }
                    
                    completeBusRoute531Expectation.fulfill()
                })
            }
        }
        
        //Get route in going way
        connectivityService.getCompleteRoads(busLineID, direction: goingDirection, completionHandler: connectivtyResultsCompletionHandler)
        
        waitForExpectations(timeout: 30)
        { error in
            
            if let error = error
            {
                print("A 30 (Thirty) seconds timeout ocurred waiting on complete road with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
    
    func testPerformanceForCompleteBusRoute531()
    {
        // Bus 531
        let busLineID:Int = 11
        let goingDirection:Int = 0
        let returningDirection:Int = 1
        let busLineName:String = "531"
        
        let connectivtyResultsCompletionHandler: (CompleteBusRoute?, NSError?) -> Void = { (justGoingBusRoute, error) in
            if let completeRoute = justGoingBusRoute
            {
                //Get route in returning way
                self.connectivityService.getCompleteRoads(busLineID, direction: returningDirection, completionHandler: { (returnBusRoute, error) in
                    
                    completeRoute.busLineName = busLineName
                    
                    if let fullCompleteRoute = returnBusRoute
                    {
                        //Another hack
                        completeRoute.returnPointList = fullCompleteRoute.goingPointList
                    }
                    
                    XCTAssert(completeRoute.goingPointList.count > 0)
                    XCTAssert(completeRoute.returnPointList.count > 0)
                    
                    XCTAssertFalse(completeRoute.isEqualStartGoingEndReturn())
                    XCTAssertFalse(completeRoute.isEqualStartReturnEndGoing())
                    
                    for case let item:RoutePoint in completeRoute.goingPointList
                    {
                        XCTAssertNotNil(item.stopId)
                        XCTAssertNotNil(item.latitude)
                        XCTAssertNotNil(item.longitude)
                        XCTAssertNotNil(item.address)
                        XCTAssertNotNil(item.isWaypoint)
                        XCTAssertNotNil(item.name)
                    }
                    
                    for case let item:RoutePoint in completeRoute.returnPointList
                    {
                        XCTAssertNotNil(item.stopId)
                        XCTAssertNotNil(item.latitude)
                        XCTAssertNotNil(item.longitude)
                        XCTAssertNotNil(item.address)
                        XCTAssertNotNil(item.isWaypoint)
                        XCTAssertNotNil(item.name)
                    }
                })
            }
        }
        
        self.measureBlock
            {
                //Get route in going way
                self.connectivityService.getCompleteRoads(busLineID, direction: goingDirection, completionHandler: connectivtyResultsCompletionHandler)
        }
    }
    
    func testResultContentsForCompleteBusRoute542()
    {
        let completeBusRoute542Expectation = expectation(description: "ConnectivityGatherCompleteBusRouteFor542")
        
        // Bus 542
        let busLineID:Int = 1
        let goingDirection:Int = 0
        let returningDirection:Int = 1
        let busLineName:String = "542"
        
        let connectivtyResultsCompletionHandler: (CompleteBusRoute?, NSError?) -> Void = { (justGoingBusRoute, error) in
            if let completeRoute = justGoingBusRoute
            {
                //Get route in returning way
                self.connectivityService.getCompleteRoads(busLineID, direction: returningDirection, completionHandler: { (returnBusRoute, error) in
                    
                    completeRoute.busLineName = busLineName
                    
                    if let fullCompleteRoute = returnBusRoute
                    {
                        //Another hack
                        completeRoute.returnPointList = fullCompleteRoute.goingPointList
                    }
                    
                    XCTAssert(completeRoute.goingPointList.count > 0)
                    XCTAssert(completeRoute.returnPointList.count > 0)
                    
                    XCTAssertFalse(completeRoute.isEqualStartGoingEndReturn())
                    XCTAssertFalse(completeRoute.isEqualStartReturnEndGoing())
                    
                    for case let item:RoutePoint in completeRoute.goingPointList
                    {
                        XCTAssertNotNil(item.stopId)
                        XCTAssertNotNil(item.latitude)
                        XCTAssertNotNil(item.longitude)
                        XCTAssertNotNil(item.address)
                        XCTAssertNotNil(item.isWaypoint)
                        XCTAssertNotNil(item.name)
                    }
                    
                    for case let item:RoutePoint in completeRoute.returnPointList
                    {
                        XCTAssertNotNil(item.stopId)
                        XCTAssertNotNil(item.latitude)
                        XCTAssertNotNil(item.longitude)
                        XCTAssertNotNil(item.address)
                        XCTAssertNotNil(item.isWaypoint)
                        XCTAssertNotNil(item.name)
                    }
                    
                    completeBusRoute542Expectation.fulfill()
                })
            }
        }
        
        //Get route in going way
        connectivityService.getCompleteRoads(busLineID, direction: goingDirection, completionHandler: connectivtyResultsCompletionHandler)
        
        waitForExpectations(timeout: 30)
        { error in
            
            if let error = error
            {
                print("A 30 (Thirty) seconds timeout ocurred waiting on complete road with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
    
    func testPerformanceForCompleteBusRoute542()
    {
        // Bus 542
        let busLineID:Int = 1
        let goingDirection:Int = 0
        let returningDirection:Int = 1
        let busLineName:String = "542"
        
        let connectivtyResultsCompletionHandler: (CompleteBusRoute?, NSError?) -> Void = { (justGoingBusRoute, error) in
            if let completeRoute = justGoingBusRoute
            {
                //Get route in returning way
                self.connectivityService.getCompleteRoads(busLineID, direction: returningDirection, completionHandler: { (returnBusRoute, error) in
                    
                    completeRoute.busLineName = busLineName
                    
                    if let fullCompleteRoute = returnBusRoute
                    {
                        //Another hack
                        completeRoute.returnPointList = fullCompleteRoute.goingPointList
                    }
                    
                    XCTAssert(completeRoute.goingPointList.count > 0)
                    XCTAssert(completeRoute.returnPointList.count > 0)
                    
                    XCTAssertFalse(completeRoute.isEqualStartGoingEndReturn())
                    XCTAssertFalse(completeRoute.isEqualStartReturnEndGoing())
                    
                    for case let item:RoutePoint in completeRoute.goingPointList
                    {
                        XCTAssertNotNil(item.stopId)
                        XCTAssertNotNil(item.latitude)
                        XCTAssertNotNil(item.longitude)
                        XCTAssertNotNil(item.address)
                        XCTAssertNotNil(item.isWaypoint)
                        XCTAssertNotNil(item.name)
                    }
                    
                    for case let item:RoutePoint in completeRoute.returnPointList
                    {
                        XCTAssertNotNil(item.stopId)
                        XCTAssertNotNil(item.latitude)
                        XCTAssertNotNil(item.longitude)
                        XCTAssertNotNil(item.address)
                        XCTAssertNotNil(item.isWaypoint)
                        XCTAssertNotNil(item.name)
                    }
                })
            }
        }
        
        self.measureBlock
            {
                //Get route in going way
                self.connectivityService.getCompleteRoads(busLineID, direction: goingDirection, completionHandler: connectivtyResultsCompletionHandler)
        }
    }
    
    func testResultContentsForRechargePoints()
    {
        let rechargePointsExpectation = expectation(description: "ConnectivityGatherRechargePoints")
        
        // Avenida Pedro Luro y Avenida Independencia
        let userLocationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.9962268, longitude: -57.5535847)
        
        connectivityService.getRechargeCardPoints(userLocationCoordinate.latitude, longitude: userLocationCoordinate.longitude)
        {
            points, error in
            
            if let rechargePoints = points
            {
                for case let item:RechargePoint in rechargePoints
                {
                    XCTAssertNotNil(item)
                    
                    XCTAssertNotNil(item.id)
                    XCTAssertNotNil(item.name)
                    XCTAssertNotNil(item.address)
                    XCTAssertNotNil(item.location)
                    XCTAssertNotNil(item.openTime)
                    XCTAssertNotNil(item.distance)
                    
                    XCTAssertGreaterThanOrEqual(item.distance!, 0.0)
                }
            }
            
            rechargePointsExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 30)
        { error in
            
            if let error = error
            {
                print("A 30 (Thirty) seconds timeout ocurred waiting on recharge points with error: \(error.localizedDescription)")
            }
            
            print("\nExpectation fulfilled!\n")
        }
    }
    
    func testPerformanceForRechargePoints()
    {
        // Avenida Pedro Luro y Avenida Independencia
        let userLocationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.9962268, longitude: -57.5535847)
        
        self.measureBlock
            {
                self.connectivityService.getRechargeCardPoints(userLocationCoordinate.latitude, longitude: userLocationCoordinate.longitude)
                {
                    points, error in
                    
                    if let rechargePoints = points
                    {
                        for case let item:RechargePoint in rechargePoints
                        {
                            XCTAssertNotNil(item)
                            
                            XCTAssertNotNil(item.id)
                            XCTAssertNotNil(item.name)
                            XCTAssertNotNil(item.address)
                            XCTAssertNotNil(item.location)
                            XCTAssertNotNil(item.openTime)
                            XCTAssertNotNil(item.distance)
                            
                            XCTAssertGreaterThanOrEqual(item.distance!, 0.0)
                        }
                    }
                }
        }
    }
    
    // MARK: - Directions Endpoints
    
    func testResultContentsForWalkingDirections()
    {
        let walkingDirectionsExpectation = expectation(description: "ConnectivityGatherWalkingDirections")
        
        // Avenida Pedro Luro and Avenida Independencia
        // To
        // Avenida Colón and Buenos Aires

        let originLocationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.9962268, longitude: -57.5535847)
        let destinationLocationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -38.005980, longitude: -57.545158)
        
        connectivityService.getWalkingDirections(originLocationCoordinate, destinationCoordinate: destinationLocationCoordinate, completionHandler: { (directionResponse, error) in
            
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
        
        self.measureBlock
            {
                self.connectivityService.getWalkingDirections(originLocationCoordinate, destinationCoordinate: destinationLocationCoordinate, completionHandler: { (directionResponse, error) in
                    
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
