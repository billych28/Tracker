//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Мамытов Руслан on 16.07.2026.
//

import UIKit

enum Constants {
    static let trackersHeaderIdentifier = "TrackerHeader"
    static let trackerCellIdentifier = "TrackerCell"
}

final class TrackersViewController: UIViewController, UISearchResultsUpdating {
    
    // MARK: - Public properties
    var visibleCategories: [TrackerCategory] = []
    var completedTracker: [TrackerRecord] = []
    var currentDate: Date = Date.now
    let collectionViewParams = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 8)
    var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Private properties
    private let datePicker = UIDatePicker()
    private let searchController = UISearchController(searchResultsController: nil)
    private var emptyView: EmptyView = {
        let view = EmptyView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var categories: [TrackerCategory] = [
        TrackerCategory(title: "iOS-разработка", trackers: [Tracker(name: "Выполнить ДЗ", emoji: "😎", colorName: .green, timetable: [.monday, .friday])])
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupNavBar()
        setupDatePicker()
        setupCollectionView()
        setupEmptyView()
        filterTrackersDyDate()
    }
    
    // MARK: - Public methods
    func updateSearchResults(for searchController: UISearchController) {
        // TODO: реализация будет в 17 спринте
    }
    
    // MARK: - Private methods
    private func setupNavBar() {
        title = "Трекеры"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        let largeTitleFont = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        appearance.largeTitleTextAttributes = [
            .font: largeTitleFont,
            .foregroundColor: UIColor(resource: .black)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        let addButton = UIBarButtonItem(image: UIImage(resource: .addIcon), style: .plain, target: self, action: #selector(handlePlusClick))
        addButton.tintColor = UIColor(resource: .black)
        let datePickerButton = UIBarButtonItem(customView: datePicker)
        
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = datePickerButton
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController = searchController
    }
    
    @objc private func handlePlusClick() {
        let createTrackerVC = CreateTrackerViewController()
        createTrackerVC.delegate = self
        let navController = UINavigationController(rootViewController: createTrackerVC)
        createTrackerVC.modalPresentationStyle = .pageSheet
        present(navController, animated: true)
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.maximumDate = Date()
        
        let changeDateAction = UIAction { [weak self] action in
            guard let self else { return }
            
            currentDate = datePicker.date
            filterTrackersDyDate()
        }
        
        datePicker.addAction(changeDateAction, for: .valueChanged)
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: Constants.trackerCellIdentifier)
        collectionView.register(CategoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.trackersHeaderIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupEmptyView() {
        view.addSubview(emptyView)
        
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    private func filterTrackersDyDate() {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: currentDate)
        guard let currentWeekday = Weekday(rawValue: weekday) else { return }
        
        var filtered: [TrackerCategory] = []
        
        for category in categories {
            let matchingTrackers = category.trackers.filter { tracker in
                tracker.timetable.contains(currentWeekday)
            }
            
            if !matchingTrackers.isEmpty {
                let filteredCategory = TrackerCategory(title: category.title, trackers: matchingTrackers)
                filtered.append(filteredCategory)
            }
        }
        
        visibleCategories = filtered
        
        updateUIState()
    }
    
    private func updateUIState() {
        let isListEmpty = visibleCategories.isEmpty
        
        collectionView.isHidden = isListEmpty
        emptyView.isHidden = !isListEmpty
        
        collectionView.reloadData()
    }
    
    private func addTracker(tracker: Tracker) {
        categories[0] = categories[0].addNewTracker(tracker)
        filterTrackersDyDate()
    }
}

// MARK: - CreateTrackerViewControllerDelegate
extension TrackersViewController: CreateTrackersViewControllerDelegate {
    func didCreateTracker(title: String, weekdays: [Weekday]) {
        let createdTracker = Tracker(name: title, emoji: "👀", colorName: .red, timetable: weekdays)
        addTracker(tracker: createdTracker)
    }
}
