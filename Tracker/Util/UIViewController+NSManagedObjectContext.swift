//
//  UIViewController+NSManagedObjectContext.swift
//  Tracker
//
//  Created by Мамытов Руслан on 18.08.2026.
//

import UIKit
import CoreData

extension UIViewController {
    var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Не удалось привести UIApplication.shared.delegate к AppDelegate")
        }
        
        return appDelegate.persistentContainer.viewContext
    }
}
