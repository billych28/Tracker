//
//  AppDelegate.swift
//  Tracker
//
//  Created by Мамытов Руслан on 16.07.2026.
//

import UIKit
import CoreData
import Logging
import AppMetricaCore

enum AppDelegateConstants {
    static let persistentContainerName = "TrackerModel"
}

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let logger = Logger(label: "com.billych28.tracker")
    
    var window: UIWindow?
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: AppDelegateConstants.persistentContainerName)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as? NSError {
                AppDelegate.logger.error("Couldn't create a NSPersistentContainer", metadata: ["view": "AppDelegate", "error": "\(error)"])
                assertionFailure()
            }
        }
        
        return container
    }()
    
    lazy var dataProvider: TrackersDataProvider = {
        let dataProvider = TrackersDataProvider(context: persistentContainer.viewContext)
        return dataProvider
    }()
    
    override init() {
        super.init()
        WeekdayArrayTransformer.register()
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let configuration = AppMetricaConfiguration(apiKey: "") {
            AppMetrica.activate(with: configuration)
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                
                let error = error as NSError
                AppDelegate.logger.error("Couldn't save context", metadata: ["view": "AppDelegate", "error": "\(error)"])
                assertionFailure()
            }
        }
    }
    
}

