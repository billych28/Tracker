//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Мамытов Руслан on 27.08.2026.
//
import Logging
import AppMetricaCore

final class AnalyticsService {
    static let shared = AnalyticsService()
    
    private init() {}
    
    func report(event: ScreenEvent, screen: ScreenName, item: String? = nil) {
        var params: [String: Any] = [
            "event": event.rawValue,
            "screen": screen.rawValue
        ]
        
        if let item {
            params["item"] = item
        }
        
        AppMetrica.reportEvent(name: "TrackerEvent", parameters: params, onFailure: { error in
            AppDelegate.logger.error("AppMetrica reportEvent error: \(error.localizedDescription)")
        })
    }
}
