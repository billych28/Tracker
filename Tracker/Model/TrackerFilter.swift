//
//  TrackerFilter.swift
//  Tracker
//
//  Created by Мамытов Руслан on 27.08.2026.
//
import Foundation

enum TrackerFilter: String, CaseIterable {
    case all
    case today
    case completed
    case uncompleted
    
    var title: String {
        switch self {
        case .all: return NSLocalizedString("filter_all_title", comment: "All trackers")
        case .today: return NSLocalizedString("filter_today_title", comment: "Today's trackers")
        case .completed: return NSLocalizedString("filter_completed_title", comment: "Completed trackers")
        case .uncompleted: return NSLocalizedString("filter_uncompleted_title", comment: "Uncompleted trackers")
        }
    }
}
