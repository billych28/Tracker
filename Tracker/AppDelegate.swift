//
//  AppDelegate.swift
//  Tracker
//
//  Created by Мамытов Руслан on 16.07.2026.
//

import UIKit
import CoreData

enum AppDelegateConstants {
    static let persistentContainerName = "TrackerModel"
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: AppDelegateConstants.persistentContainerName)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as? NSError {
                assertionFailure("Ошибка при создании PersistentStore: \(error)")
            }
        }
        
        return container
    }()
    
    override init() {
        super.init()
        WeekdayArrayTransformer.register()
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
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
                assertionFailure("Произошла ошибка при сохранении контекста: \(error)")
            }
        }
    }
    
}

