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
        
        let trackersTabBarItemTitle = NSLocalizedString("trackers_title", comment: "Trackers TabBarItem title")
        let statisticsTabBarItemTitle = NSLocalizedString("statistics_title", comment: "Statistics TabBarItem title")
        
        trackersVC.tabBarItem = UITabBarItem(
            title: trackersTabBarItemTitle,
            image: UIImage(resource: .trackersIcon),
            tag: 0
        )
        statisticsVC.tabBarItem = UITabBarItem(
            title: statisticsTabBarItemTitle,
            image: UIImage(resource: .statisticsIcon),
            tag: 1
        )
        
        self.viewControllers = [nav1, nav2]
    }
    
    private func setTabBarDivider() {
        let appearance = UITabBarAppearance()
            
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = UIColor.gray
        appearance.backgroundColor = .YPColors.white
                
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
