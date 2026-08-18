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
}
