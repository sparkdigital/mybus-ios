//
//  Connectivity.swift
//  MyBus
//
//  Created by Marcos Vivar on 4/13/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Alamofire
import SwiftyJSON

private let _sharedInstance = Connectivity()

private let municipalityAccessToken = "rwef3253465htrt546dcasadg4343"

private let municipalityBaseURL = "http://gis.mardelplata.gob.ar/opendata/ws.php?method=rest"

private let streetNamesEndpointURL = "\(municipalityBaseURL)&endpoint=callejero_mgp&token=\(municipalityAccessToken)&nombre_calle="

private let addressToCoordinateEndpointURL = "\(municipalityBaseURL)&endpoint=callealtura_coordenada&token=\(municipalityAccessToken)"

private let coordinateToAddressEndpointURL = "\(municipalityBaseURL)&endpoint=coordenada_calleaaltura&token=\(municipalityAccessToken)"

public class Connectivity: NSObject
{
    // MARK: - Instantiation
    public class var sharedInstance: Connectivity
    {
        return _sharedInstance
    }
    
    override init() { }
    
    // MARK: Municipality Endpoints
    func getStreetNames(forName streetName: String, completionHandler: ([Street]?, NSError?) -> ())
    {
        let escapedStreet = streetName.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())! as String
        let streetNameURLString = "\(streetNamesEndpointURL)\(escapedStreet)"
        
        let request = NSMutableURLRequest(URL: NSURL(string: streetNameURLString)!)
        request.HTTPMethod = "GET"
        
        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .Success(let value):
                var streetsNames : [Street] = [Street]()
                let json = JSON(value)
                if let streets = json.array {
                    for street in streets {
                        streetsNames.append(Street(json: street))
                    }
                }
                completionHandler(streetsNames, nil)
            case .Failure(let error):
                print("\nError: \(error)")
                completionHandler(nil, error)
            }
        }
    }
    
    public func getAddressFromCoordinate(latitude : Double, longitude: Double, completionHandler: (NSDictionary?, NSError?) -> ())
    {
        print("You tapped at: \(latitude), \(longitude)")
        let addressFromCoordinateURLString = "\(coordinateToAddressEndpointURL)&latitud=\(latitude)&longitud=\(longitude)"
        
        let request = NSMutableURLRequest(URL: NSURL(string: addressFromCoordinateURLString)!)
        request.HTTPMethod = "GET"
        
        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .Success(let value):
                completionHandler(value as? NSDictionary, nil)
            case .Failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
}