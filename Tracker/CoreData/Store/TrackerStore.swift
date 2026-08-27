//
//  TrackerStore.swift
//  Tracker
//
//  Created by Мамытов Руслан on 18.08.2026.
//

import CoreData

final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createTracker(from tracker: Tracker, in categoryCoreData: TrackerCategoryCoreData) throws -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.colorHex = UIColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.timetable = tracker.timetable as NSObject
        trackerCoreData.category = categoryCoreData
        
        try context.save()
        return trackerCoreData
    }
    
    func updateTracker(
        _ tracker: Tracker,
        newTitle: String,
        weekdays: [Weekday],
        emoji: String,
        colorHex: String,
        in categoryCoreData: TrackerCategoryCoreData
    ) throws {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        let results = try context.fetch(request)
        guard let trackerCoreData = results.first else {
            throw NSError(domain: "TrackerStore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Tracker not found"])
        }
        
        trackerCoreData.name = newTitle
        trackerCoreData.emoji = emoji
        trackerCoreData.colorHex = colorHex
        trackerCoreData.timetable = weekdays as NSObject
        trackerCoreData.category = categoryCoreData
        
        try context.save()
    }
    
    func deleteTracker(_ tracker: Tracker) throws {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        let results = try context.fetch(request)
        guard let trackerCoreData = results.first else {
            throw NSError(domain: "TrackerStore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Tracker not found for deletion"])
        }
        
        context.delete(trackerCoreData)
        
        try context.save()
    }
}
