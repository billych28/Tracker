//
//  MainTabBarController.swift
//  Tracker
//
//  Created by Мамытов Руслан on 16.07.2026.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private let dataProvider: TrackersDataProvider
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setTabBarDivider()
    }
    
    init(dataProvider: TrackersDataProvider) {
        self.dataProvider = dataProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    private func setupTabs() {
        let trackersVC = TrackersViewController()
        let statisticsVC = StatisticsViewController()
        
        trackersVC.configure(with: dataProvider)
        
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
