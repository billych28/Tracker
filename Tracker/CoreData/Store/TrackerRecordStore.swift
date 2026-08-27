//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Мамытов Руслан on 18.08.2026.
//
import CoreData

final class TrackerRecordStore: NSObject {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func add(_ record: TrackerRecord, to trackerCoreData: TrackerCoreData) throws {
        let recordCoreData = TrackerRecordCoreData(context: context)
        recordCoreData.id = record.id
        recordCoreData.date = Calendar.current.startOfDay(for: record.date)
        recordCoreData.tracker = trackerCoreData
        
        try context.save()
    }
    
    func fetchCompletedTrackersIDs(for date: Date) -> [UUID] {
        let calendar = Calendar.current
        
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            return []
        }
        
        let request = TrackerRecordCoreData.fetchRequest()
        
        // Ищем записи строго внутри выбранных суток
        request.predicate = NSPredicate(
            format: "date >= %@ AND date < %@",
            startOfDay as NSDate,
            endOfDay as NSDate
        )
        
        do {
            let recordsCoreData = try context.fetch(request)
            
            let completedIDs = recordsCoreData.compactMap { record -> UUID? in
                return record.tracker?.id
            }
    
            return completedIDs
        } catch {
            return []
        }
    }
    
    func remove(_ record: TrackerRecord) throws {
        let request = TrackerRecordCoreData.fetchRequest()
        
        let targetDate = Calendar.current.startOfDay(for: record.date)
        request.predicate = NSPredicate(format: "id == %@ AND date == %@", record.id as CVarArg, targetDate as NSDate)
        
        if let results = try context.fetch(request).first {
            context.delete(results)
            try context.save()
        }
    }
}
