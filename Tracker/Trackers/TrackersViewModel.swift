//
//  LoginViewModel.swift
//  Tracker
//
//  Created by Мамытов Руслан on 19.08.2026.
//

import Foundation

typealias Binding<T> = (T) -> Void

final class TrackersViewModel: TrackersViewModelProtocol {
    
    // MARK: - Public properties
    var onDataUpdated: Binding<Void>?
    var onEmptyStateChanged: Binding<Bool>?
    var numberOfSections: Int {
        dataProvider.numberOfSections
    }
    
    // MARK: - Private properties
    private let dataProvider: TrackersDataProvider
    
    // MARK: - Initializer
    init(dataProvider: TrackersDataProvider) {
        self.dataProvider = dataProvider
        self.dataProvider.delegate = self
    }
    
    // MARK: - Public methods
    func filterTrackers(by date: Date, searchString: String, filter: TrackerFilter) {
        let cleanText = searchString.trimmingCharacters(in: .whitespacesAndNewlines)
        dataProvider.updateFilter(date: date, searchText: cleanText, filter: filter)
        notifyViewAboutChanges()
    }
    
    func addNewTracker(title: String, weekdays: [Weekday], emoji: String, colorHex: String, currentDate: Date, toCategory: String) {
        let color = UIColorMarshalling.color(from: colorHex)
        let createdTracker = Tracker(id: UUID(), name: title, emoji: emoji, color: color, timetable: weekdays)
        dataProvider.add(newTracker: createdTracker, toCategoryTitle: toCategory)
        dataProvider.updateFilter(date: currentDate, searchText: "")
        notifyViewAboutChanges()
    }
    
    func updateTracker(
        _ tracker: Tracker,
        newTitle: String,
        weekdays: [Weekday],
        emoji: String,
        colorHex: String,
        newCategory: String,
        currentDate: Date
    ) {
        dataProvider.updateTracker(
            tracker,
            newTitle: newTitle,
            weekdays: weekdays,
            emoji: emoji,
            colorHex: colorHex,
            newCategoryTitle: newCategory
        )
        notifyViewAboutChanges()
    }
    
    func deleteTracker(_ tracker: Tracker) {
        dataProvider.deleteTracker(tracker)
        notifyViewAboutChanges()
    }
    
    func toggleCompletion(for tracker: Tracker, on date: Date) {
        dataProvider.toggleCompletion(for: tracker, on: date)
        notifyViewAboutChanges()
    }
    
    func completionDetails(for tracker: Tracker, on date: Date) -> (count: Int, isCompleted: Bool) {
        dataProvider.completionDetails(for: tracker, on: date)
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        dataProvider.numberOfItemsInSection(section)
    }
    
    func categoryTitle(at section: Int) -> String {
        dataProvider.categoryTitle(at: section)
    }
    
    func tracker(at indexPath: IndexPath) -> Tracker? {
        dataProvider.tracker(at: indexPath)
    }
    
    // MARK: - Private Methods
    private func notifyViewAboutChanges() {
        onDataUpdated?(())
        
        let isEmpty = dataProvider.numberOfSections == 0
        onEmptyStateChanged?(isEmpty)
    }
}

// MARK: TrackersDataProviderDelegate
extension TrackersViewModel: TrackersDataProviderDelegate {
    func dataProviderDidChangeContent() {
        notifyViewAboutChanges()
    }
}
