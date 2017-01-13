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
            let results = digitRegEx.matches(in: openTime as String, options: [], range: NSMakeRange(0, openTime.length))

            guard results.count == 4 || results.count == 8 else {
                self.isOpen = true
                return
            }

            let resultsFiltered = results.map { openTime.substring(with: $0.range)}

            guard let openHour = Int(resultsFiltered[0]), let openMinutes = Int(resultsFiltered[1]), let closeHour = Int(resultsFiltered[2]), let closeMinutes = Int(resultsFiltered[3]) else {
                self.isOpen = true
                return
            }

            let currentCalendar = NSCalendar.current
            let now = Date()
            var openDateComponents = currentCalendar.dateComponents([.year, .month, .day, .hour, .minute, .weekday, .weekOfYear],
                                                      from: now)
            openDateComponents.hour = openHour
            openDateComponents.minute = openMinutes
            let openDate = currentCalendar.date(from: openDateComponents)
            
            
            var closeDateComponents = currentCalendar.dateComponents([.year, .month, .day, .hour, .minute, .weekday, .weekOfYear],
                                                      from: now)
            closeDateComponents.hour = closeHour
            closeDateComponents.minute = closeMinutes
            let closeDate = currentCalendar.date(from: closeDateComponents)
            
            guard let pointOpenDate = openDate, let pointCloseDate = closeDate else {
                self.isOpen = true
                return
            }
            
            let minutesDiffOpen = Calendar.current.dateComponents([.minute], from: pointOpenDate, to: now).minute
            let minutesDiffClose = Calendar.current.dateComponents([.minute], from: pointCloseDate, to: now).minute
            
            
            var isOpen = minutesDiffOpen! >= 0 && minutesDiffClose! < 0

            if results.count == 8 {
                //Hace horario cortado
                guard let openHour = Int(resultsFiltered[4]), let openMinutes = Int(resultsFiltered[5]), let closeHour = Int(resultsFiltered[6]), let closeMinutes = Int(resultsFiltered[7]) else {
                    self.isOpen = isOpen
                    return
                }
                
                var afternoonOpenDateComponents = currentCalendar.dateComponents([.year, .month, .day, .hour, .minute, .weekday, .weekOfYear],
                                                                         from: now)
                afternoonOpenDateComponents.hour = openHour
                afternoonOpenDateComponents.minute = openMinutes
                
                let afternoonOpenDate = currentCalendar.date(from: afternoonOpenDateComponents)
                
                
                var afternoonCloseDateComponents = currentCalendar.dateComponents([.year, .month, .day, .hour, .minute, .weekday, .weekOfYear],
                                                                                 from: now)
                afternoonCloseDateComponents.hour = closeHour
                afternoonCloseDateComponents.minute = closeMinutes
                let afternoonCloseDate = currentCalendar.date(from: afternoonCloseDateComponents)
    
                guard let pointAfternoonOpenDate = afternoonOpenDate, let pointAfternoonCloseDate = afternoonCloseDate else {
                    self.isOpen = true
                    return
                }
                let minutesDiffOpen = Calendar.current.dateComponents([.minute], from: pointAfternoonOpenDate, to: now).minute
                let minutesDiffClose = Calendar.current.dateComponents([.minute], from: pointAfternoonCloseDate, to: now).minute
                isOpen = (minutesDiffOpen! >= 0 && minutesDiffClose! < 0) || isOpen
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
