//
//  MainTabBarController.swift
//  Tracker
//
//  Created by Мамытов Руслан on 16.07.2026.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setTabBarDivider()
    }
    
    // MARK: - Private methods
    private func setupTabs() {
        let trackersViewModel = TrackersViewModel(dataProvider: dataProvider)
        let trackersVC = TrackersViewController(viewModel: trackersViewModel)
        let statisticsVC = StatisticsViewController()
        
        let nav1 = UINavigationController(rootViewController: trackersVC)
        let nav2 = UINavigationController(rootViewController: statisticsVC)
        
        trackersVC.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(resource: .trackersIcon),
            tag: 0
        )
        statisticsVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(resource: .statisticsIcon),
            tag: 1
        )
        
        self.viewControllers = [nav1, nav2]
    }
    
    private func setTabBarDivider() {
        let appearance = UITabBarAppearance()
            
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = UIColor.gray
                
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
