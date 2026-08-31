//
//  TrackersDataProvider+Category.swift
//  Tracker
//
//  Created by Мамытов Руслан on 27.08.2026.
//
import CoreData
import Logging

extension TrackersDataProvider {
    func numberOfItemsInSection(_ section: Int) -> Int {
        guard section < visibleCategories.count else { return 0 }
        return visibleCategories[section].trackers.count
    }
    
    func categoryTitle(at section: Int) -> String {
        guard section < visibleCategories.count else { return "" }
        return visibleCategories[section].title
    }
    
    func fetchAllCategories() -> [String] {
        let request = TrackerCategoryCoreData.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)]
        
        do {
            let categoriesCoreData = try context.fetch(request)
            return categoriesCoreData.compactMap { $0.title }
        } catch {
            AppDelegate.logger.error("Failed to fetch all categories from Core Data", metadata: ["view": "TrackersDataProvider", "error": "\(error)"])
            return []
        }
    }
    
    func addCategory(with title: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        
        do {
            _ = try categoryStore.fetchOrCreateCategory(with: trimmedTitle)
        } catch {
            AppDelegate.logger.error("Couldn't add new empty category", metadata: ["view": "TrackersDataProvider", "error": "\(error)"])
        }
    }
    
    func updateCategory(oldTitle: String, newTitle: String) {
        do {
            try categoryStore.updateCategory(from: oldTitle, to: newTitle)
        } catch {
            AppDelegate.logger.error("Couldn't update tracker category", metadata: ["view": "TrackersDataProvider", "error": "\(error)"])
        }
    }
    
    func deleteCategory(with title: String) {
        do {
            try categoryStore.deleteCategory(with: title)
        } catch {
            AppDelegate.logger.error("Couldn't delete tracker category", metadata: ["view": "TrackersDataProvider", "error": "\(error)"])
        }
    }
    
    func rebuildVisibleCategories() {
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
