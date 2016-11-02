//
//  RegExpOperator.swift
//  MyBus
//
//  Created by Lisandro Falconi on 9/28/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation

prefix operator ~/ {}

prefix func ~/ (pattern: String) -> NSRegularExpression {
    return try! NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
}

func ~= (pattern: NSRegularExpression, str: String) -> Bool {
    return pattern.numberOfMatchesInString(str, options: [], range: NSRange(location: 0, length: str.characters.count)) > 0
}
