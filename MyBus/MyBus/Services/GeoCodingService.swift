//
//  GeoCodingService.swift
//  MyBus
//
//  Created by Lisandro Falconi on 5/28/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol GeoCodingServiceDelegate {
    func getCoordinateFromAddress(streetName: String, completionHandler: (JSON?, NSError?) -> ())
}

private let googleMapsGeocodingBaseURL = "https://maps.googleapis.com/maps/api/geocode/json?"

private let googleGeocodingApiKey = "AIzaSyCXgPZbEkpO_KsQqr5_q7bShcOhRlvodyc"

public class GeoCodingService: NSObject, GeoCodingServiceDelegate {
    public func getCoordinateFromAddress(streetName: String, completionHandler: (JSON?, NSError?) -> ())
    {
        print("Address to resolve geocoding: \(streetName)")
        let address = "\(streetName), mar del plata"
        var coordinateFromAddressURLString = "\(googleMapsGeocodingBaseURL)&address=\(address)&components=administrative_area:General Pueyrredón&key=\(googleGeocodingApiKey)"
        coordinateFromAddressURLString = coordinateFromAddressURLString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())! as String
        let request = NSMutableURLRequest(URL: NSURL(string: coordinateFromAddressURLString)!)
        request.HTTPMethod = "GET"

        Alamofire.request(request).responseJSON { response in
            switch response.result
            {
            case .Success(let value):
                let json = JSON(value)
                completionHandler(json, nil)
            case .Failure(let error):
                print("\nError: \(error)")
                completionHandler(nil, error)
            }
        }
    }
}
