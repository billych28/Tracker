//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Мамытов Руслан on 16.07.2026.
//

import UIKit

final class StatisticsViewController: UIViewController {
    // MARK: - Private properties
    private let emptyView: EmptyView = {
        let view = EmptyView()
        view.setTitle(to: NSLocalizedString("statistics_empty_state_title", comment: "Empty state title"))
        view.setImage(with: UIImage(resource: .statisticEmptyIcon))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let bestPeriodCard = StatisticCardView(title: NSLocalizedString("statistics_best_period", comment: "Best period"))
    private let perfectDaysCard = StatisticCardView(title: NSLocalizedString("statistics_perfect_days", comment: "Perfect days"))
    private let completedCard = StatisticCardView(title: NSLocalizedString("statistics_total_completed", comment: "Trackers completed"))
    private let averageCard = StatisticCardView(title: NSLocalizedString("statistics_average", comment: "Average"))
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatistics()
    }
    
    // MARK: - Private methods
    private func setupScreen() {
        title = NSLocalizedString("statistics_title", comment: "Statistics title")
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .YPColors.white
    }
    
    private func setupLayout() {
        view.addSubview(emptyView)
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(bestPeriodCard)
        stackView.addArrangedSubview(perfectDaysCard)
        stackView.addArrangedSubview(completedCard)
        stackView.addArrangedSubview(averageCard)
        
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 77),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
        ])
    }
    
    private func updateStatistics() {
        let stats = dataProvider.fetchStatistics()
        
        if stats.completedTrackersCount == 0 {
            stackView.isHidden = true
            emptyView.isHidden = false
        } else {
            stackView.isHidden = false
            emptyView.isHidden = true
            
            bestPeriodCard.setValue(stats.bestPeriod)
            perfectDaysCard.setValue(stats.perfectDays)
            completedCard.setValue(stats.completedTrackersCount)
            averageCard.setValue(stats.averageValue)
        }
    }
}
