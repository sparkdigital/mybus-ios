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
    public func getStreetNames(forName streetName: String)
    {
        let streetNameURLString = "\(streetNamesEndpointURL)\(streetName)"
        
        let request = NSMutableURLRequest(URL: NSURL(string: streetNameURLString)!)
        request.HTTPMethod = "GET"
        
        Alamofire.request(request).responseJSON { (response) -> Void in
            
            if(response.result.isFailure)
            {
                print("\nError: \(response.result.error!)")
            }
            else
            {
                let resultValue = response.result.value!
                
                print(resultValue)
                
                var bodyData: NSData?
                do
                {
                    bodyData = try NSJSONSerialization.dataWithJSONObject(resultValue, options: .PrettyPrinted)
                    print(bodyData)
                }
                catch
                {
                    bodyData = nil
                    print(error)
                }
            }
        }
    }
    
}