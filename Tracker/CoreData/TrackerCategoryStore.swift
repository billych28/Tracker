//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Мамытов Руслан on 18.08.2026.
//

import CoreData

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchOrCreateCategory(with title: String) throws -> TrackerCategoryCoreData {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        
        if let existingCategory = try context.fetch(request).first {
            return existingCategory
        } else {
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.title = title
            try context.save()
            return newCategory
        }
    }
    
    func updateCategory(from oldTitle: String, to newTitle: String) throws {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", oldTitle)
        
        if let categoryCoreData = try context.fetch(request).first {
            categoryCoreData.title = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
            try context.save()
        }
    }
    
    func deleteCategory(with title: String) throws {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        
        if let categoryCoreData = try context.fetch(request).first {
            context.delete(categoryCoreData)
            try context.save()
        }
    }
}
