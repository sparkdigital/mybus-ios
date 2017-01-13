//
//  Configuration.swift
//  MyBus
//
//  Created by Lisandro Falconi on 7/28/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation

class Configuration {
    fileprivate static let streetsArray = NSArray(contentsOfFile: Bundle.main.path(forResource: "Streets", ofType: "plist")!)!
    fileprivate static let busessArray = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "BusesRates", ofType: "plist")!)!
    fileprivate static let infoBussesArray = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "BusesRates", ofType: "plist")!)!
    fileprivate static let colorBussesArray = NSArray(contentsOfFile: Bundle.main.path(forResource: "BusColors", ofType: "plist")!)!
    fileprivate static let suggestedPlacesArray = NSArray(contentsOfFile: Bundle.main.path(forResource: "SuggestedPlaces", ofType: "plist")!)!

    fileprivate static let thirdServicesConfiguration = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "AppConfiguration", ofType: "plist")!)!
    
    fileprivate static let thirdServicesConfigurationTwo = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "AppConfiguration", ofType: "plist")!)!

    class func streetsName() -> [String] {
        return Configuration.streetsArray as! [String]
    }

    class func bussesRates() -> [(String, String)]{
        var rates = [(String, String)]()
        for item in Configuration.busessArray{
            rates.append((item.key as! String, item.value as! String))
        }
        var sortedArray = rates.sorted { (element1, element2) -> Bool in
            return element1.0 < element2.0
        }
        let aux = sortedArray.popLast()
        sortedArray.insert(aux!, at: 0)
        return sortedArray
    }

    class func bussesInformation() -> [(String, String, String)]{
        var information = [(String, String, String)]()
        for item in colorBussesArray {
            var itemTwo = item as! [String: Any]
            information.append((itemTwo["id"] as! String, itemTwo["name"] as! String, itemTwo["color"] as! String))
        }
        let sortedArray = information.sorted { (element1, element2) -> Bool in
            return element1.1 < element2.1
        }
        return sortedArray
    }

    class func suggestedPlaces() -> [SuggestedPlace]{
        return Configuration.suggestedPlacesArray.map { (placeDict) -> SuggestedPlace in
            return SuggestedPlace(object: placeDict as! NSDictionary)
        }
    }

    // MARK: MyBus Service Configuration
    class func myBusApiKey() -> String {
        let third = Configuration.thirdServicesConfigurationTwo["ThirdServices"] as! NSDictionary
        let mybus = third["MyBus"] as! NSDictionary
        
        return mybus["ApiKey"] as! String
    }

    class func myBusApiUrl() -> String {
        let third = Configuration.thirdServicesConfigurationTwo["ThirdServices"] as! NSDictionary
        let mybus = third["MyBus"] as! NSDictionary
        
        return mybus["ApiURL"] as! String
//        return Configuration.thirdServicesConfiguration["ThirdServices"]!["MyBus"]!!["ApiURL"] as! String
    }

    // MARK: Google GeoCoding Service Configuration
    class func googleGeocodingURL()->String{
        let third = Configuration.thirdServicesConfigurationTwo["ThirdServices"] as! NSDictionary
        let mybus = third["GoogleGeocoding"] as! NSDictionary
        
        return mybus["ApiURL"] as! String
    }

    class func googleGeocodingAPIKey()->String{
        let third = Configuration.thirdServicesConfigurationTwo["ThirdServices"] as! NSDictionary
        let mybus = third["GoogleGeocoding"] as! NSDictionary
        
        return mybus["ApiKey"] as! String
    }

    // MARK: Flurry SDK Service Configuration
    class func flurryAPIKey()->String{
        let third = Configuration.thirdServicesConfigurationTwo["ThirdServices"] as! NSDictionary
        return third["FlurryApiKey"] as! String
    }

    // MARK: MapBox SDK Service Configuration
    class func mapBoxAPIKey()->String{
        let third = Configuration.thirdServicesConfigurationTwo["ThirdServices"] as! NSDictionary
        return third["MapboxAPIKey"] as! String
    }
}
