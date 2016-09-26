//
//  BusSearchResultStringFormatter.swift
//  MyBus
//
//  Created by Lisandro Falconi on 8/16/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

extension BusSearchResult {
    /**
    Using available BusRouteResults bus line ids we create an string to display in results table view

     :returns: Array of bus result string
    */
    func stringifyBusRoutes() -> [String] {
        return self.busRouteOptions.map { (busRouteResult: BusRouteResult) -> String in
            getStringBusResultRow(busRouteResult)
        }
    }

    /**
    Concating 🚍 with bus line number(s) is used as dictonary key or to display in results table row

     :returns: Emoji and bus line number(s) string
     */
    func getStringBusResultRow(busRouteResult: BusRouteResult) -> String {
        var 🚌 : String = "🚍"
        for route in busRouteResult.busRoutes {
            let busLineFormatted = route.busLineName!.characters.count == 3 ? route.busLineName!+"  " : route.busLineName!
            🚌 = "\(🚌) \(busLineFormatted) ➡"
        }
        🚌.removeAtIndex(🚌.endIndex.predecessor())
        return 🚌
    }
}
