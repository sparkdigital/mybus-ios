//
//  Location.swift
//  MyBus
//
//  Created by Lisandro Falconi on 4/18/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object
{
    dynamic var name:String = ""
    dynamic var latitude:Double = 0
    dynamic var longitude:Double = 0
    dynamic var streetCode:Int = 0
    dynamic var streetName:String = ""
    dynamic var houseNumber:Int = 0
}