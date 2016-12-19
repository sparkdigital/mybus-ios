//
//  RechargePoint.swift
//  MyBus
//
//  Created by Lisandro Falconi on 9/13/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import SwiftyJSON
import Mapbox

struct RechargePoint {
    let id: String
    let name: String
    let address: String
    let location: (latitude: Double, longitude: Double)
    let openTime: String
    let distance: Double?
    let isOpen: Bool
}

extension RechargePoint {
    init?(json: JSON) {
        guard let id = json["Id"].string,
            let name = json["Name"].string,
            let address = json["Adress"].string,
            let latitude = json["Lat"].string,
            let longitude = json["Lng"].string,
            let openTime = json["OpenTime"].string,
            let distance = json["Distance"].string
            else {
                return nil
        }

        self.id = id
        self.name = name
        self.address = address
        self.location = (Double(latitude)!, Double(longitude)!)
        self.openTime = openTime
        self.distance = Double(distance)
        do {
            let digitRegEx = try NSRegularExpression(pattern: "[0-9]{2}", options: [])
            let openTime = openTime as NSString
            let results = digitRegEx.matchesInString(openTime as String, options: [], range: NSMakeRange(0, openTime.length))

            guard results.count == 4 || results.count == 8 else {
                self.isOpen = true
                return
            }

            let resultsFiltered = results.map { openTime.substringWithRange($0.range)}

            guard let openHour = Int(resultsFiltered[0]), openMinutes = Int(resultsFiltered[1]), closeHour = Int(resultsFiltered[2]), closeMinutes = Int(resultsFiltered[3]) else {
                self.isOpen = true
                return
            }

            let currentCalendar = NSCalendar.currentCalendar()
            let now = NSDate()
            let openDate = currentCalendar.dateBySettingHour(openHour, minute: openMinutes, second: 0, ofDate: NSDate(), options: [])
            let closeDate = currentCalendar.dateBySettingHour(closeHour, minute: closeMinutes, second: 0, ofDate: NSDate(), options: [])
            guard let pointOpenDate = openDate, pointCloseDate = closeDate else {
                self.isOpen = true
                return
            }
            let minutesDiffOpen = NSCalendar.currentCalendar().components(.Minute, fromDate: pointOpenDate, toDate: now, options: []).minute
            let minutesDiffClose = NSCalendar.currentCalendar().components(.Minute, fromDate: pointCloseDate, toDate: now, options: []).minute
            var isOpen = minutesDiffOpen >= 0 && minutesDiffClose < 0

            if results.count == 6 {
                //Hace horario cortado
                guard let openHour = Int(resultsFiltered[4]), openMinutes = Int(resultsFiltered[5]), closeHour = Int(resultsFiltered[6]), closeMinutes = Int(resultsFiltered[7]) else {
                    self.isOpen = isOpen
                    return
                }

                let afternoonOpenDate = currentCalendar.dateBySettingHour(openHour, minute: openMinutes, second: 0, ofDate: NSDate(), options: [])
                let afternoonCloseDate = currentCalendar.dateBySettingHour(closeHour, minute: closeMinutes, second: 0, ofDate: NSDate(), options: [])
                guard let pointAfternoonOpenDate = afternoonOpenDate, pointAfternoonCloseDate = afternoonCloseDate else {
                    self.isOpen = true
                    return
                }
                let minutesDiffOpen = NSCalendar.currentCalendar().components(.Minute, fromDate: pointAfternoonOpenDate, toDate: now, options: []).minute
                let minutesDiffClose = NSCalendar.currentCalendar().components(.Minute, fromDate: pointAfternoonCloseDate, toDate: now, options: []).minute
                isOpen = (minutesDiffOpen >= 0 && minutesDiffClose < 0) || isOpen
            }

            self.isOpen = isOpen


        } catch {
            self.isOpen = true
        }
    }

    func getLatLong() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
}
