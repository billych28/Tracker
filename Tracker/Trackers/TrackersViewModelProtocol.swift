//
//  TrackersViewModelProtocol.swift
//  Tracker
//
//  Created by Мамытов Руслан on 27.08.2026.
//
import Foundation

protocol TrackersViewModelProtocol: AnyObject {
    var onDataUpdated: Binding<Void>? { get set }
    var onEmptyStateChanged: Binding<Bool>? { get set }
    var numberOfSections: Int { get }
    
    func toggleCompletion(for tracker: Tracker, on date: Date)
    func completionDetails(for tracker: Tracker, on date: Date) -> (count: Int, isCompleted: Bool)
    func numberOfItemsInSection(_ section: Int) -> Int
    func categoryTitle(at section: Int) -> String
    func tracker(at indexPath: IndexPath) -> Tracker?
    func filterTrackers(by date: Date, searchString: String, filter: TrackerFilter)
    func addNewTracker(title: String, weekdays: [Weekday], emoji: String, colorHex: String, currentDate: Date, toCategory: String)
    func updateTracker(_ tracker: Tracker, newTitle: String, weekdays: [Weekday], emoji: String, colorHex: String, newCategory: String, currentDate: Date)
    func deleteTracker(_ tracker: Tracker)
}
