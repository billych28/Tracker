//
//  TrackerSettingsStorageProtocol.swift
//  Tracker
//
//  Created by Мамытов Руслан on 27.08.2026.
//
import Foundation

final class TrackerSettingsStorage: TrackerSettingsStorageProtocol {
    
    // MARK: - Private properties
    private let userDefaults = UserDefaults.standard
    private let filterKey = "selected_tracker_filter"
    
    // MARK: - Public properties
    var selectedFilter: TrackerFilter {
        get {
            guard let rawValue = userDefaults.string(forKey: filterKey),
                  let filter = TrackerFilter(rawValue: rawValue) else {
                return .all
            }
            return filter
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: filterKey)
        }
    }
}
