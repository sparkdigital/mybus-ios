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

private let _sharedInstance = LoggingManager()

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

    // MARK: Public interface
    func startAppLogging(){
        logCrashlytics("App Started")
        logFlurry("App Started")
    }

    func logSection(section: String){
        let legend: String = "Switched to \(section)"
        logCrashlytics(legend)
        logFlurry(legend)
    }

    func logError(sender: String, error: NSError?){
        let errorDescription = error?.description ?? "No description available"
        let legend: String = "\(sender) - Error: \(errorDescription)"
        logCrashlytics(legend)
        logFlurry(legend)
    }

}
