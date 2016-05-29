//
//  BaseNetworkService.swift
//  MyBus
//
//  Created by Lisandro Falconi on 5/29/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BaseNetworkService: NSObject {
    func performRequest(urlString: String, completionHandler: (JSON?, NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
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
