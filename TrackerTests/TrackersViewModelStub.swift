//
//  TrackersViewModelStub.swift
//  Tracker
//
//  Created by Мамытов Руслан on 27.08.2026.
//
import UIKit
@testable import Tracker

final class TrackersViewModelStub: TrackersViewModelProtocol {
    var onDataUpdated: Binding<Void>? = nil
    var onEmptyStateChanged: Binding<Bool>? = nil
    
    let numberOfSections: Int = 1
    
    func toggleCompletion(for tracker: Tracker, on date: Date) {
    }
    
    func completionDetails(for tracker: Tracker, on date: Date) -> (count: Int, isCompleted: Bool) {
        (0, false)
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        1
    }
    
    func categoryTitle(at section: Int) -> String {
        "Тест"
    }
    
    func tracker(at indexPath: IndexPath) -> Tracker? {
        onEmptyStateChanged?(false)
        return Tracker(id: UUID(), name: "Привычка", emoji: "👀", color: .red, timetable: [.friday])
    }
    
    func filterTrackers(by date: Date) {
    }
    
    func addNewTracker(title: String, weekdays: [Weekday], emoji: String, colorHex: String, currentDate: Date, toCategory: String) {
    }
    
}
