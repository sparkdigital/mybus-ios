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
    private static let thirdServicesConfiguration = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("AppConfiguration", ofType: "plist")!)!

    class func streetsName() -> [String] {
        return Configuration.streetsArray as! [String]
    }

    class func myBusApiKey() -> String {
        return Configuration.thirdServicesConfiguration["ThirdServices"]!["MyBus"]!!["ApiKey"] as! String
    }

    class func myBusApiUrl() -> String {
        return Configuration.thirdServicesConfiguration["ThirdServices"]!["MyBus"]!!["ApiURL"] as! String
    }
    
    class func googleGeocodingURL()->String{
        return Configuration.thirdServicesConfiguration["ThirdServices"]!["GoogleGeocoding"]!!["ApiURL"] as! String
    }
    
    class func googleGeocodingAPIKey()->String{
        return Configuration.thirdServicesConfiguration["ThirdServices"]!["GoogleGeocoding"]!!["ApiKey"] as! String
    }
    
}
