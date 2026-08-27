//
//  TrackersDataProvider+Tracker.swift
//  Tracker
//
//  Created by Мамытов Руслан on 27.08.2026.
//

import UIKit
import CoreData
import Logging

extension TrackersDataProvider {
    func tracker(at indexPath: IndexPath) -> Tracker? {
        guard indexPath.section < visibleCategories.count,
              indexPath.row < visibleCategories[indexPath.section].trackers.count else {
            return nil
        }
        return visibleCategories[indexPath.section].trackers[indexPath.row]
    }
    
    func add(newTracker: Tracker, toCategoryTitle title: String) {
        do {
            let categoryCoreData = try categoryStore.fetchOrCreateCategory(with: title)
            _ = try trackerStore.createTracker(from: newTracker, in: categoryCoreData)
        } catch {
            AppDelegate.logger.error("Couldn't add new tracker to category \(title)", metadata: ["view": "TrackersDataProvider", "error": "\(error)"])
        }
    }
    
    func updateTracker(
        _ tracker: Tracker,
        newTitle: String,
        weekdays: [Weekday],
        emoji: String,
        colorHex: String,
        newCategoryTitle: String
    ) {
        do {
            let categoryRequest = TrackerCategoryCoreData.fetchRequest()
            categoryRequest.predicate = NSPredicate(format: "title == %@", newCategoryTitle)
            
            guard let targetCategoryCoreData = try context.fetch(categoryRequest).first else {
                AppDelegate.logger.error("Selected category not found during tracker update")
                return
            }
            
            try trackerStore.updateTracker(
                tracker,
                newTitle: newTitle,
                weekdays: weekdays,
                emoji: emoji,
                colorHex: colorHex,
                in: targetCategoryCoreData
            )
            
            rebuildVisibleCategories()
            delegate?.dataProviderDidChangeContent()
        } catch {
            AppDelegate.logger.error("Failed to update tracker through DataProvider", metadata: [
                "trackerID": "\(tracker.id)",
                "error": "\(error)"
            ])
        }
    }
    
    func deleteTracker(_ tracker: Tracker) {
        do {
            try trackerStore.deleteTracker(tracker)
            rebuildVisibleCategories()
            delegate?.dataProviderDidChangeContent()
        } catch {
            AppDelegate.logger.error("Failed to delete tracker through DataProvider", metadata: [
                "trackerID": "\(tracker.id)",
                "error": "\(error)"
            ])
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
            AppDelegate.logger.error("Couldn't toggle tracker completion status", metadata: ["view": "TrackersDataProvider", "error": "\(error)"])
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
}
