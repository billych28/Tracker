//
//  UIViewController+NSManagedObjectContext.swift
//  Tracker
//
//  Created by Мамытов Руслан on 18.08.2026.
//

import UIKit
import CoreData
import Logging

extension UIViewController {
    var dataProvider: TrackersDataProvider {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            AppDelegate.logger.error("Не удалось привести UIApplication.shared.delegate к AppDelegate")
            fatalError()
        }
        
        return appDelegate.dataProvider
    }
}
