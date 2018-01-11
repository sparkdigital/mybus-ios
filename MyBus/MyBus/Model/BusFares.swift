//
//  BusFares.swift
//  MYBUS
//
//  Created by Lisandro Falconi on 11/01/2018.
//  Copyright © 2018 Spark Digital. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BusFares {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let type = "Type"
        static let results = "Results"
    }
    
    // MARK: Properties
    public var type: Int?
    public var results: [(line: String, price:String)]?
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public init(json: JSON) {
        type = json[SerializationKeys.type].int
        if let items = json[SerializationKeys.results].array { results = items.map { ((line: $0.arrayValue[0].stringValue, price: $0.arrayValue[1].stringValue)) } }
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = type { dictionary[SerializationKeys.type] = value }
        if let value = results { dictionary[SerializationKeys.results] = value }
        return dictionary
    }
    
}
