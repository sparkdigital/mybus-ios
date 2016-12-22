//
//  LoggingManager.swift
//  MyBus
//
//  Created by Sebastian Fink on 12/7/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import Foundation
import Crashlytics
import Flurry_iOS_SDK
import Firebase
import FirebaseMessaging
import FirebaseAnalytics

private let _sharedInstance = LoggingManager()

enum LoggableAppSection:String {
    case MAP = "Search and Map Visualization"
    case FAVOURITES = "Favourites"
    case RECHARGE = "Recharge Points"
    case ROUTES = "Bus Routes"
    case FARES = "Bus Fares"
    case TERMS = "Terms and Conditions"
    case ABOUT = "About Us"
}

enum LoggableAppEvent:String {
    case FAVORITE_NEW_PLUS = "New Favorite from form"
    case FAVORITE_NEW_MARKER = "New Favorite from map annotation"
    case FAVORITE_DEL_LIST = "Removed Favorite from Wishlist"
    case FAVORITE_DEL_MARKER = "Removed Favorite from marker"
    case FAVORITE_EDIT_LIST = "Favorite content was edited"
    case MARKER_DRAGGED = "Endpoint dragged in map"
    case INVERT_TAPPED = "Invert endpoints"
    case ROUTE_SELECTED = "Bus route selected"
    case ROUTE_GOING_TAPPED = "Bus route selector going"
    case ROUTE_RETURN_TAPPED = "Bus route selector return"
    case ENDPOINT_FROM_LONGPRESS = "Endpoint from map long press"
    case ENDPOINT_FROM_SUGGESTION = "Endpoint from suggestion"
    case ENDPOINT_FROM_RECENTS = "Endpoint from recent location"
    case ENDPOINT_FROM_FAVORITES = "Endpoint from favorite location"
    case ENDPOINT_GPS_MAP = "Endpont from current location - Map"
    case ENDPOINT_GPS_SEARCH = "Endpoint from current location - Search"
}

public class LoggingManager: NSObject {

    private static let flurryApiKey: String = Configuration.flurryAPIKey()
    private static var logTimestamp: NSTimeInterval {
        return NSDate().timeIntervalSince1970 * 1000
    }

    var crashlyticsClassInstance: AnyObject {
        return Crashlytics.self
    }

    // MARK: - Singleton Instantiation
    public class var sharedInstance: LoggingManager {
        return _sharedInstance
    }

    private override init() {
        super.init()
    }

    func setup(){
        setupCrashlytics()
        setupFlurry()
        setupFirebase()
    }
    
    private func setupFirebase(){
        //Initialize Firebase
        FIRApp.configure()
    }

    private func setupCrashlytics(){
        //No custom setup at the moment
    }

    private func setupFlurry(){
        Flurry.setLogLevel(FlurryLogLevelDebug)
        Flurry.setCrashReportingEnabled(true)
        Flurry.startSession(LoggingManager.flurryApiKey)
    }

    private func logCrashlytics(event: String){
        Answers.logCustomEventWithName(event, customAttributes: ["evt_timestamp" : LoggingManager.logTimestamp])
    }

    private func logFlurry(event: String){
        Flurry.logEvent(event)
    }
    
    private func logFirebaseEvent(event:LoggableAppEvent){
        FIRAnalytics.logEventWithName(event.rawValue, parameters: nil)
    }
    
    private func logFirebaseSection(section:LoggableAppSection){
        FIRAnalytics.logEventWithName(section.rawValue, parameters: nil)
    }
    
    private func logFirebaseError(error:String){
        FIRAnalytics.logEventWithName("Error", parameters: [kFIRParameterValue:error])
    }
    
    // MARK: Public interface
    func startAppLogging(){
        logCrashlytics("AppStarted")
        logFlurry("AppStarted")
    }

    func logSection(section: LoggableAppSection){
        let legend: String = "Entered to \(section.rawValue)"
        logCrashlytics(legend)
        logFlurry(legend)
        logFirebaseSection(section)
    }
    
    func logEvent(event: LoggableAppEvent){
        let legend:String = "Event = \(event.rawValue)"
        logFlurry(legend)
        logCrashlytics(legend)
        logFirebaseEvent(event)
    }

    func logError(sender: String, error: NSError?){
        let errorDescription = error?.description ?? "No description available"
        let legend: String = "\(sender) - Error: \(errorDescription)"
        logCrashlytics(legend)
        logFlurry(legend)
        logFirebaseError(errorDescription)
    }

}
