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
    
    var numberOfSections: Int {
        visibleCategories.count
    }
    
    // MARK: - Private properties
    private let context: NSManagedObjectContext
    private let trackerStore: TrackerStore
    private let recordStore: TrackerRecordStore
    private let categoryStore: TrackerCategoryStore
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!
    private var currentSelectedWeekday: Weekday?
    private var visibleCategories: [TrackerCategory] = []
    
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
    
    private func setCurrentDate() {
        let weekdayComponent = Calendar.current.component(.weekday, from: Date())
        self.currentSelectedWeekday = Weekday(rawValue: weekdayComponent)
    }
    
    // MARK: - Public methods
    func numberOfItemsInSection(_ section: Int) -> Int {
        guard section < visibleCategories.count else { return 0 }
        return visibleCategories[section].trackers.count
    }
    
    func categoryTitle(at section: Int) -> String {
        guard section < visibleCategories.count else { return "" }
        return visibleCategories[section].title
    }
    
    func tracker(at indexPath: IndexPath) -> Tracker? {
        guard indexPath.section < visibleCategories.count,
              indexPath.row < visibleCategories[indexPath.section].trackers.count else {
            return nil
        }
        return visibleCategories[indexPath.section].trackers[indexPath.row]
    }
    
    func filterTrackers(by date: Date) {
        let weekdayComponent = Calendar.current.component(.weekday, from: date)
        guard let currentWeekday = Weekday(rawValue: weekdayComponent) else { return }
        
        currentSelectedWeekday = currentWeekday
        rebuildVisibleCategories()
    }
    
    func add(newTracker: Tracker, toCategoryTitle title: String) {
        do {
            let categoryCoreData = try categoryStore.fetchOrCreateCategory(with: title)
            _ = try trackerStore.createTracker(from: newTracker, in: categoryCoreData)
        } catch {
            AppDelegate.logger.error("Couldn't add new tracker", metadata: ["view": "TrackersDataProvider", "error": "\(error)"])
        }
    }
    
    func toggleCompletion(for tracker: Tracker, on date: Date) {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        guard let trackerCoreData = try? context.fetch(request).first else { return }
        let records = trackerCoreData.records as? Set<TrackerRecordCoreData> ?? []
        let isCompleted = records.contains { Calendar.current.isDate($0.date ?? Date(), inSameDayAs: date) }
        
        do {
            let record = TrackerRecord(id: tracker.id, date: date)
            if isCompleted {
                try recordStore.remove(record)
            } else {
                try recordStore.add(record, to: trackerCoreData)
            }
            
            context.refresh(trackerCoreData, mergeChanges: true)
            
        } catch {
            AppDelegate.logger.error("Couldn't toggle tracker completion status", metadata: ["view": "TrackersData", "error": "\(error)"])
        }
    }
    
    func completionDetails(for tracker: Tracker, on date: Date) -> (count: Int, isCompleted: Bool) {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        guard let trackerCoreData = try? context.fetch(request).first else { return (0, false) }
        let records = trackerCoreData.records as? Set<TrackerRecordCoreData> ?? []
        
        let count = records.count
        let isCompleted = records.contains { record in
            guard let recordDate = record.date else { return false }
            return Calendar.current.isDate(recordDate, inSameDayAs: date)
        }
        
        return (count, isCompleted)
    }
    
    // MARK: - Private methods
    private func rebuildVisibleCategories() {
        guard
            let sections = fetchedResultsController.sections,
            let currentWeekday = currentSelectedWeekday
        else {
            visibleCategories = []
            return
        }
        
        visibleCategories = sections.compactMap { section in
            let trackersCoreData = section.objects as? [TrackerCoreData] ?? []
            
            let filteredTrackers = trackersCoreData.compactMap { coreDataObj -> Tracker? in
                guard
                    let id = coreDataObj.id,
                    let name = coreDataObj.name
                else {
                    return nil
                }
                
                let timetable = coreDataObj.timetable as? [Weekday] ?? []
                
                guard timetable.contains(currentWeekday) else { return nil }
                
                let color = UIColorMarshalling.color(from: coreDataObj.colorHex ?? "#FFFFFF")
                return Tracker(id: id, name: name, emoji: coreDataObj.emoji ?? "👀", color: color, timetable: timetable)
            }
            
            if filteredTrackers.isEmpty { return nil }
            return TrackerCategory(title: section.name, trackers: filteredTrackers)
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackersDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        rebuildVisibleCategories()
        delegate?.dataProviderDidChangeContent()
    }
}
