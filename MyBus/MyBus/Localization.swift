//
//  Localization.swift
//  MyBus
//
//  Created by Nacho on 11/30/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

class Localization: NSObject {

    class func getLocalizedString(key : String) -> String{        
        return NSLocalizedString(key, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
    
}
