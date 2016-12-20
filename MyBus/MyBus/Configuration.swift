//
//  Configuration.swift
//  MyBus
//
//  Created by Lisandro Falconi on 7/28/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation

class Configuration {
    private static let streetsArray = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("Streets", ofType: "plist")!)!
    private static let busessArray = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("BusesRates", ofType: "plist")!)!
    private static let infoBussesArray = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("BusesRates", ofType: "plist")!)!
    private static let colorBussesArray = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("BusColors", ofType: "plist")!)!
    private static let suggestedPlacesArray = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("SuggestedPlaces", ofType: "plist")!)!

    private static let thirdServicesConfiguration = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("AppConfiguration", ofType: "plist")!)!

    // MARK: Gis Service Configuration
    class func gisMunicipalityApiURL()->String{
        return Configuration.thirdServicesConfiguration["ThirdServices"]!["GisMGPMunicipality"]!!["ApiURL"] as! String
    }

    class func gisMunicipalityApiWebServicePath()->String{
        return Configuration.thirdServicesConfiguration["ThirdServices"]!["GisMGPMunicipality"]!!["ApiWSPath"] as! String
    }

    class func gisMunicipalityApiAccessToken()->String{
        return Configuration.thirdServicesConfiguration["ThirdServices"]!["GisMGPMunicipality"]!!["ApiKey"] as! String
    }

    class func streetsName() -> [String] {
        return Configuration.streetsArray as! [String]
    }

    class func bussesRates() -> [(String, String)]{
        var rates = [(String, String)]()
        for item in Configuration.busessArray{
            rates.append((item.key as! String, item.value as! String))
        }
        var sortedArray = rates.sort { (element1, element2) -> Bool in
            return element1.0 < element2.0
        }
        let aux = sortedArray.popLast()
        sortedArray.insert(aux!, atIndex: 0)
        return sortedArray
    }

    class func bussesInformation() -> [(String, String, String)]{
        var information = [(String, String, String)]()
        for item in colorBussesArray{
            information.append(item["id"] as! String, item["name"] as! String, item["color"] as! String)
        }
        let sortedArray = information.sort { (element1, element2) -> Bool in
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
        return Configuration.thirdServicesConfiguration["ThirdServices"]!["MyBus"]!!["ApiKey"] as! String
    }

    class func myBusApiUrl() -> String {
        return Configuration.thirdServicesConfiguration["ThirdServices"]!["MyBus"]!!["ApiURL"] as! String
    }

    // MARK: Google GeoCoding Service Configuration
    class func googleGeocodingURL()->String{
        return Configuration.thirdServicesConfiguration["ThirdServices"]!["GoogleGeocoding"]!!["ApiURL"] as! String
    }

    class func googleGeocodingAPIKey()->String{
        return Configuration.thirdServicesConfiguration["ThirdServices"]!["GoogleGeocoding"]!!["ApiKey"] as! String
    }

    // MARK: Flurry SDK Service Configuration
    class func flurryAPIKey()->String{
        return Configuration.thirdServicesConfiguration["ThirdServices"]!["FlurryApiKey"]! as! String
    }

    // MARK: MapBox SDK Service Configuration
    class func mapBoxAPIKey()->String{
        return Configuration.thirdServicesConfiguration["ThirdServices"]!["MapboxAPIKey"]! as! String
    }
}
