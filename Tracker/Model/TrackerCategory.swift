//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Мамытов Руслан on 21.07.2026.
//

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
    
    func addNewTracker(_ newTracker: Tracker) -> TrackerCategory {
        return TrackerCategory(title: self.title, trackers: self.trackers + [newTracker])
    }
}
