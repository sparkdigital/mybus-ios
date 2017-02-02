//
//  RoadSearch.swift
//  MyBus
//
//  Created by Lisandro Falconi on 5/28/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation

open class RoadSearch {
    var idFirstLine: Int = 0
    var idSecondLine: Int = 0
    var firstDirection: Int = 0
    var secondDirection: Int = 0
    var beginStopFirstLine: Int = 0
    var endStopFirstLine: Int = 0
    var beginStopSecondLine: Int = 0
    var endStopSecondLine: Int = 0

    init(singleRoad idFirstLine: Int, firstDirection: Int, beginStopFirstLine: Int, endStopFirstLine: Int)
    {
        self.idFirstLine = idFirstLine
        self.firstDirection = firstDirection
        self.beginStopFirstLine = beginStopFirstLine
        self.endStopFirstLine = endStopFirstLine
    }

    init(combinedRoad idFirstLine: Int, firstDirection: Int, beginStopFirstLine: Int, endStopFirstLine: Int,
        idSecondLine: Int, secondDirection: Int, beginStopSecondLine: Int, endStopSecondLine: Int)
    {
        self.idFirstLine = idFirstLine
        self.idSecondLine = idSecondLine

        self.firstDirection = firstDirection
        self.secondDirection = secondDirection

        self.beginStopFirstLine = beginStopFirstLine
        self.endStopFirstLine = endStopFirstLine

        self.beginStopSecondLine = beginStopSecondLine
        self.endStopSecondLine = endStopSecondLine
    }

    convenience init?()
    {
        let idFirstLine = 0
        let firstDirection = 0
        let beginStopFirstLine = 0
        let endStopFirstLine = 0

        self.init(singleRoad: idFirstLine, firstDirection: firstDirection, beginStopFirstLine: beginStopFirstLine, endStopFirstLine: endStopFirstLine)
    }
}
