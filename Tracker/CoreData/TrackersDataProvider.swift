//
//  TrackersDataProvider.swift
//  Tracker
//
//  Created by Мамытов Руслан on 18.08.2026.
//

import UIKit
import CoreData
import Logging

final class TrackersDataProvider: NSObject {
    // MARK: - Public properties
    weak var delegate: TrackersDataProviderDelegate?
    
    var visibleCategories: [TrackerCategory] = []
    var numberOfSections: Int {
        visibleCategories.count
    }
    
    // MARK: - Private properties
    private var currentFilter: TrackerFilter = .all
    private(set) var trackerStore: TrackerStore
    private(set) var recordStore: TrackerRecordStore
    private(set) var categoryStore: TrackerCategoryStore
    private(set) var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!
    private(set) var currentSelectedWeekday: Weekday?
    private(set) var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.trackerStore = TrackerStore(context: context)
        self.recordStore = TrackerRecordStore(context: context)
        self.categoryStore = TrackerCategoryStore(context: context)
        super.init()
        
        setupFetchedResultsController()
        setCurrentDate()
        rebuildVisibleCategories()
    }
    
    private func setupFetchedResultsController() {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.category?.title, ascending: true),
            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "category.title",
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        
        try? controller.performFetch()
    }
    
    // MARK: - Public methods
    func updateFilter(date: Date, searchText: String, filter: TrackerFilter? = nil) {
        if let filter = filter {
            self.currentFilter = filter
        }
        
        let calendar = Calendar.current
        let weekdayComponent = calendar.component(.weekday, from: date)
        self.currentSelectedWeekday = Weekday(rawValue: weekdayComponent)
        
        var predicates: [NSPredicate] = []
        
        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "name CONTAINS[cd] %@", searchText))
        }
        
        let startOfDay = calendar.startOfDay(for: date)
        let completedTrackerIDs = recordStore.fetchCompletedTrackersIDs(for: startOfDay)
        
        switch currentFilter {
        case .all, .today:
            break
        case .completed:
            predicates.append(NSPredicate(format: "id IN %@", completedTrackerIDs))
        case .uncompleted:
            predicates.append(NSPredicate(format: "NOT (id IN %@)", completedTrackerIDs))
        }
        
        if predicates.isEmpty {
            fetchedResultsController.fetchRequest.predicate = nil
        } else {
            fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        
        do {
            try fetchedResultsController.performFetch()
            rebuildVisibleCategories()
            delegate?.dataProviderDidChangeContent()
        } catch {
            AppDelegate.logger.error("Failed to fetch filtered trackers", metadata: ["error": "\(error)"])
        }
    }
    
    // MARK: - Private methods
    private func setCurrentDate() {
        let weekdayComponent = Calendar.current.component(.weekday, from: Date())
        self.currentSelectedWeekday = Weekday(rawValue: weekdayComponent)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackersDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        rebuildVisibleCategories()
        delegate?.dataProviderDidChangeContent()
    }
}
