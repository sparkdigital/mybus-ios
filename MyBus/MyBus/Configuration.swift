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
    
    class func bussesRates() -> [String:String] {
        return Configuration.busessArray as! [String:String]
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
    
}
