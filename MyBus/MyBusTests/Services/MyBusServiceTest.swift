//
//  MyBusServiceTest.swift
//  MyBus
//
//  Created by Marcos Jesus Vivar on 11/24/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import XCTest
import MapKit
@testable import MyBus

class MyBusServiceTest: XCTestCase
{
    let myBusService = MyBusService()
    
    override func setUp()
    {
        super.setUp()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: - MyBus Endpoints
    
    func testResultContentsForBusLinesFromOriginDestinationSingle()
    {
        let busLinesFromOriginDestinationSingleExpectation = expectationWithDescription("MyBusGatherBusLinesFromOriginDestinationSingle")
        
        // El Gaucho Monument's LAT/LON coordinates
        let originCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.999347899999997, longitude: -57.596915499999987)
        
        // Av. Independencia & Av. Pedro Luro LAT/LON coordinates
        let destinationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.995540099999999, longitude: -57.552269300000013)
        
        myBusService.searchRoutes(originCoordinate.latitude, longitudeOrigin: originCoordinate.longitude, latitudeDestination: destinationCoordinate.latitude, longitudeDestination: destinationCoordinate.longitude) { (busRouteResultArray, error) in
            
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
        
        waitForExpectationsWithTimeout(90)
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
                self.myBusService.searchRoutes(originCoordinate.latitude, longitudeOrigin: originCoordinate.longitude, latitudeDestination: destinationCoordinate.latitude, longitudeDestination: destinationCoordinate.longitude) { (busRouteResultArray, error) in
                    
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
        let busLinesFromOriginDestinationCombinedExpectation = expectationWithDescription("MyBusGatherBusLinesFromOriginDestinationCombined")
        
        // El Gaucho Monument's LAT/LON coordinates
        let originCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.999347899999997, longitude: -57.596915499999987)
        
        // Luzuriaga 301 LAT/LON coordinates
        let destinationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -38.086793900000004, longitude: -57.548919800000007)
        
        myBusService.searchRoutes(originCoordinate.latitude, longitudeOrigin: originCoordinate.longitude, latitudeDestination: destinationCoordinate.latitude, longitudeDestination: destinationCoordinate.longitude) { (busRouteResultArray, error) in
            
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
        
        waitForExpectationsWithTimeout(120)
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
                self.myBusService.searchRoutes(originCoordinate.latitude, longitudeOrigin: originCoordinate.longitude, latitudeDestination: destinationCoordinate.latitude, longitudeDestination: destinationCoordinate.longitude) { (busRouteResultArray, error) in
                    
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
        let singleRoadResultExpectation = expectationWithDescription("MyBusGatherSingleRoadResult")
        
        // Bus 522 | From Origin: "Rosales 3458" to Destination: "Brasil 316"
        let busIDLine:Int = 9
        let direction:Int = 1
        let beginStopLine:Int = 50
        let endStopLine:Int = 158
        
        let singleRoadSearch =  RoadSearch(singleRoad: busIDLine, firstDirection: direction, beginStopFirstLine: beginStopLine, endStopFirstLine: endStopLine)
        
        myBusService.searchRoads(.Single, roadSearch: singleRoadSearch, completionHandler: { (roadResult, error) in
            
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
        })
        
        waitForExpectationsWithTimeout(60)
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
        
        let singleRoadSearch =  RoadSearch(singleRoad: busIDLine, firstDirection: direction, beginStopFirstLine: beginStopLine, endStopFirstLine: endStopLine)
        
        self.measureBlock
            {
                self.myBusService.searchRoads(.Single, roadSearch: singleRoadSearch, completionHandler: { (roadResult, error) in
                    
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
                })
        }
    }
    
    func testResultContentsForCombinedRoadResult()
    {
        let combinedRoadResultExpectation = expectationWithDescription("MyBusGatherCombinedRoadResult")
        
        // Buses 531 -> 511b | From Origin: "Luzuriaga 301" to Destination: "Velez Sarfield 257"
        let firstBusIDLine:Int = 11
        let firstDirection:Int = 0
        let firstBeginStopLine:Int = 11
        let firstEndStopLine:Int = 27
        
        let secondBusIDLine:Int = 28
        let secondDirection:Int = 0
        let secondBeginStopLine:Int = 38
        let secondEndStopLine:Int = 131
        
        let combinedRoadSearch =  RoadSearch(combinedRoad: firstBusIDLine, firstDirection: firstDirection, beginStopFirstLine: firstBeginStopLine, endStopFirstLine: firstEndStopLine, idSecondLine: secondBusIDLine, secondDirection: secondDirection, beginStopSecondLine: secondBeginStopLine, endStopSecondLine: secondEndStopLine)
        
        myBusService.searchRoads(.Combined, roadSearch: combinedRoadSearch, completionHandler:
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
        })
        
        waitForExpectationsWithTimeout(90)
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
        
        let combinedRoadSearch =  RoadSearch(combinedRoad: firstBusIDLine, firstDirection: firstDirection, beginStopFirstLine: firstBeginStopLine, endStopFirstLine: firstEndStopLine, idSecondLine: secondBusIDLine, secondDirection: secondDirection, beginStopSecondLine: secondBeginStopLine, endStopSecondLine: secondEndStopLine)
        
        self.measureBlock
            {
                self.myBusService.searchRoads(.Combined, roadSearch: combinedRoadSearch, completionHandler:
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
                })
        }
    }
    
    func testResultContentsForCompleteBusRoute531()
    {
        let completeBusRoute531Expectation = expectationWithDescription("MyBusGatherCompleteBusRouteFor531")
        
        // Bus 531
        let busLineID:Int = 11
        let goingDirection:Int = 0
        let returningDirection:Int = 1
        let busLineName:String = "531"
        
        let connectivtyResultsCompletionHandler: (CompleteBusRoute?, NSError?) -> Void = { (justGoingBusRoute, error) in
            if let completeRoute = justGoingBusRoute
            {
                //Get route in returning way
                self.myBusService.getCompleteRoads(busLineID, direction: returningDirection, completionHandler: { (returnBusRoute, error) in
                    
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
        myBusService.getCompleteRoads(busLineID, direction: goingDirection, completionHandler: connectivtyResultsCompletionHandler)
        
        waitForExpectationsWithTimeout(30)
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
                self.myBusService.getCompleteRoads(busLineID, direction: returningDirection, completionHandler: { (returnBusRoute, error) in
                    
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
                self.myBusService.getCompleteRoads(busLineID, direction: goingDirection, completionHandler: connectivtyResultsCompletionHandler)
        }
    }
    
    func testResultContentsForCompleteBusRoute542()
    {
        let completeBusRoute542Expectation = expectationWithDescription("MyBusGatherCompleteBusRouteFor542")
        
        // Bus 542
        let busLineID:Int = 1
        let goingDirection:Int = 0
        let returningDirection:Int = 1
        let busLineName:String = "542"
        
        let connectivtyResultsCompletionHandler: (CompleteBusRoute?, NSError?) -> Void = { (justGoingBusRoute, error) in
            if let completeRoute = justGoingBusRoute
            {
                //Get route in returning way
                self.myBusService.getCompleteRoads(busLineID, direction: returningDirection, completionHandler: { (returnBusRoute, error) in
                    
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
        myBusService.getCompleteRoads(busLineID, direction: goingDirection, completionHandler: connectivtyResultsCompletionHandler)
        
        waitForExpectationsWithTimeout(30)
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
                self.myBusService.getCompleteRoads(busLineID, direction: returningDirection, completionHandler: { (returnBusRoute, error) in
                    
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
                self.myBusService.getCompleteRoads(busLineID, direction: goingDirection, completionHandler: connectivtyResultsCompletionHandler)
        }
    }
    
    func testResultContentsForRechargePoints()
    {
        let rechargePointsExpectation = expectationWithDescription("MyBusGatherRechargePoints")
        
        // Avenida Pedro Luro y Avenida Independencia
        
        let userLocationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.9962268, longitude: -57.5535847)
        
        myBusService.getRechargeCardPoints(userLocationCoordinate.latitude, longitude: userLocationCoordinate.longitude)
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
        
        waitForExpectationsWithTimeout(30)
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
                self.myBusService.getRechargeCardPoints(userLocationCoordinate.latitude, longitude: userLocationCoordinate.longitude)
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
}
