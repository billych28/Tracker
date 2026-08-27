//
//  TrackersDataProvider+Statistics.swift
//  Tracker
//
//  Created by Мамытов Руслан on 27.08.2026.
//
import CoreData

// MARK: - Methods for statistics
extension TrackersDataProvider {
    func fetchStatistics() -> StatisticsModel {
        let allRecords = fetchAllRecords()
        let uniqueDays = extractUniqueDays(from: allRecords)
        
        return StatisticsModel(
            bestPeriod: calculateBestPeriod(from: uniqueDays),
            perfectDays: calculatePerfectDays(from: uniqueDays, allRecords: allRecords),
            completedTrackersCount: allRecords.count,
            averageValue: calculateAverage(totalCompleted: allRecords.count, uniqueDaysCount: uniqueDays.count)
        )
    }
}

private extension TrackersDataProvider {
    
    func fetchAllRecords() -> [TrackerRecordCoreData] {
        let request = TrackerRecordCoreData.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }
    
    func extractUniqueDays(from records: [TrackerRecordCoreData]) -> [Date] {
        let daysSet = Set(records.compactMap { record -> Date? in
            guard let date = record.date else { return nil }
            return Calendar.current.startOfDay(for: date)
        })
        return Array(daysSet).sorted()
    }
    
    func calculateAverage(totalCompleted: Int, uniqueDaysCount: Int) -> Int {
        guard uniqueDaysCount > 0 else { return 0 }
        return Int(Double(totalCompleted) / Double(uniqueDaysCount))
    }
    
    func calculateBestPeriod(from sortedDays: [Date]) -> Int {
        guard !sortedDays.isEmpty else { return 0 }
        
        var bestPeriod = 0
        var currentPeriod = 0
        var previousDay: Date?
        
        for day in sortedDays {
            if let prev = previousDay {
                let difference = Calendar.current.dateComponents([.day], from: prev, to: day).day ?? 0
                if difference == 1 {
                    currentPeriod += 1
                } else if difference > 1 {
                    bestPeriod = max(bestPeriod, currentPeriod)
                    currentPeriod = 1
                }
            } else {
                currentPeriod = 1
            }
            previousDay = day
        }
        
        return max(bestPeriod, currentPeriod)
    }
    
    func calculatePerfectDays(from uniqueDays: [Date], allRecords: [TrackerRecordCoreData]) -> Int {
        var perfectDaysCount = 0
        
        for day in uniqueDays {
            if isPerfectDay(day, allRecords: allRecords) {
                perfectDaysCount += 1
            }
        }
        
        return perfectDaysCount
    }
    
    func isPerfectDay(_ day: Date, allRecords: [TrackerRecordCoreData]) -> Bool {
        let weekdayComponent = Calendar.current.component(.weekday, from: Date())
        guard let weekday = Weekday(rawValue: weekdayComponent) else { return false }
        
        let plannedCount = countPlannedTrackers(for: weekday)
        guard plannedCount > 0 else { return false }
        
        let completedCount = countCompletedTrackers(for: day, in: allRecords)
        
        return completedCount >= plannedCount
    }
    
    func countPlannedTrackers(for weekday: Weekday) -> Int {
        let request = TrackerCoreData.fetchRequest()
        
        do {
            let allTrackersCoreData = try context.fetch(request)
            
            let plannedTrackers = allTrackersCoreData.filter { trackerCoreData in
                let timetable = trackerCoreData.timetable as? [Weekday] ?? []
                return timetable.contains(weekday)
            }
            
            return plannedTrackers.count
        } catch {
            return 0
        }
    }
    
    func countCompletedTrackers(for day: Date, in allRecords: [TrackerRecordCoreData]) -> Int {
        let recordsForDay = allRecords.filter { record in
            guard let recDate = record.date else { return false }
            return Calendar.current.isDate(recDate, inSameDayAs: day)
        }
        
        let uniqueTrackersOnDay = Set(recordsForDay.compactMap { $0.tracker?.id })
        return uniqueTrackersOnDay.count
    }
}
