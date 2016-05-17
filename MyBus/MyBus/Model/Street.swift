//
//  Street.swift
//  MyBus
//
//  Created by Julián Astrada on 4/18/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit
import SwiftyJSON

class Street: NSObject {

    var code : String
    var name : String

    init(json: JSON){
        self.code = json["codigo"].stringValue
        self.name = json["descripcion"].stringValue
    }

}
