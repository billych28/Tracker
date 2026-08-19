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
}
