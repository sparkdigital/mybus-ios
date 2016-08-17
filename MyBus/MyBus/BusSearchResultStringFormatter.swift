//
//  BusSearchResultStringFormatter.swift
//  MyBus
//
//  Created by Lisandro Falconi on 8/16/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

extension BusSearchResult {
    func stringifyBusRoutes() -> [String] {
        var busResults: [String] = []
        for busRouteResult in self.busRouteOptions {
            var 🚌 : String = "🚍"
            for route in busRouteResult.busRoutes {
                let busLineFormatted = route.busLineName!.characters.count == 3 ? route.busLineName!+"  " : route.busLineName!
                🚌 = "\(🚌) \(busLineFormatted) ➡"
            }
            🚌.removeAtIndex(🚌.endIndex.predecessor())
            busResults.append(🚌)
        }
        return busResults
    }
}
