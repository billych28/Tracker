//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Мамытов Руслан on 16.07.2026.
//

import UIKit
import AppMetricaCore

final class TrackersViewController: UIViewController {
    
    // MARK: - Public properties
    let datePicker = UIDatePicker()
    let collectionViewParams = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 8)
    let viewModel: TrackersViewModelProtocol
    var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .YPColors.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Private properties
    private var selectedFilter: TrackerFilter {
        get { settingsStorage.selectedFilter }
        set { settingsStorage.selectedFilter = newValue }
    }
    private var emptyView: EmptyView = {
        let view = EmptyView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let settingsStorage: TrackerSettingsStorageProtocol = TrackerSettingsStorage()
    private let searchController = UISearchController(searchResultsController: nil)
    private let filtersButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        
        configuration.baseBackgroundColor = UIColor(resource: .YPColors.blue)
        configuration.title = NSLocalizedString("filters_button_title", comment: "Filters button title")
        
        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Initializer
    init(viewModel: TrackersViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .YPColors.white
        
        bindViewModel()
        setupNavBar()
        setupDatePicker()
        setupCollectionView()
        setupEmptyView()
        setupFiltersButton()
        applyCurrentFilters()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsService.shared.report(event: .open, screen: .main)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AnalyticsService.shared.report(event: .close, screen: .main)
    }
    
    // MARK: - Public methods
    func editTracker(for tracker: Tracker, at indexPath: IndexPath, with count: Int) {
        let categoryTitle = viewModel.categoryTitle(at: indexPath.section)
        
        let editTrackerVC = CreateTrackerViewController(editingTracker: tracker, categoryTitle: categoryTitle, completionCount: count)
        editTrackerVC.delegate = self
        
        let navController = UINavigationController(rootViewController: editTrackerVC)
        present(navController, animated: true)
    }
    
    // MARK: - Private methods
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] _ in
            guard let self else { return }
            
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.reloadData()
        }
        
        viewModel.onEmptyStateChanged = { [weak self] isEmpty in
            guard let self else { return }
            onEmptyStateChanged(isEmpty: isEmpty)
        }
    }
    
    private func onEmptyStateChanged(isEmpty: Bool) {
        emptyView.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
        
        let isSearching = searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
        let hasActiveFilter = selectedFilter == .completed || selectedFilter == .uncompleted
        
        if isEmpty {
            if isSearching || hasActiveFilter {
                emptyView.setImage(with: UIImage(resource: .searchEmptyIcon))
                emptyView.setTitle(to: NSLocalizedString("trackers_search_empty_state_title", comment: "Empty state title"))
                
                filtersButton.isHidden = !hasActiveFilter
            } else {
                emptyView.setImage(with: UIImage(resource: .emptyIcon))
                emptyView.setTitle(to: NSLocalizedString("trackers_empty_state_title", comment: "Empty state title"))
                
                filtersButton.isHidden = true
            }
        } else {
            filtersButton.isHidden = false
        }
    }
    
    private func setupNavBar() {
        title = NSLocalizedString("trackers_title", comment: "Trackers NavBar title")
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        let largeTitleFont = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        appearance.largeTitleTextAttributes = [
            .font: largeTitleFont,
            .foregroundColor: UIColor(resource: .YPColors.black)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        let addButton = UIBarButtonItem(image: UIImage(resource: .addIcon), style: .plain, target: self, action: #selector(handlePlusClick))
        addButton.tintColor = UIColor(resource: .YPColors.black)
        let datePickerButton = UIBarButtonItem(customView: datePicker)
        
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = datePickerButton
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("trackers_search_placeholder", comment: "Placeholder for search field in Trackers screen")
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    @objc private func handlePlusClick() {
        AnalyticsService.shared.report(event: .click, screen: .main, item: "add_track")
        let createTrackerVC = CreateTrackerViewController()
        createTrackerVC.delegate = self
        let navController = UINavigationController(rootViewController: createTrackerVC)
        present(navController, animated: true)
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.maximumDate = Date()
        
        let changeDateAction = UIAction { [weak self] action in
            guard let self else { return }
            
            if selectedFilter == .today {
                selectedFilter = .all
            }
            applyCurrentFilters()
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
        
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        collectionView.verticalScrollIndicatorInsets = collectionView.contentInset
    }
    
    private func setupEmptyView() {
        view.addSubview(emptyView)
        
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    private func setupFiltersButton() {
        view.addSubview(filtersButton)
        
        NSLayoutConstraint.activate([
            filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filtersButton.widthAnchor.constraint(equalToConstant: 114),
            filtersButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            
            AnalyticsService.shared.report(event: .click, screen: .main, item: "filter")
            presentFiltersViewController()
        }
        filtersButton.addAction(action, for: .touchUpInside)
    }
    
    private func presentFiltersViewController() {
        let filtersVC = FiltersViewController(currentFilter: selectedFilter)
        filtersVC.delegate = self
        let navController = UINavigationController(rootViewController: filtersVC)
        present(navController, animated: true)
    }
    
    private func applyCurrentFilters() {
        let selectedDate = datePicker.date
        let searchText = searchController.searchBar.text ?? ""
        
        viewModel.filterTrackers(by: selectedDate, searchString: searchText, filter: selectedFilter)
    }
}

// MARK: - CreateTrackerViewControllerDelegate
extension TrackersViewController: CreateTrackersViewControllerDelegate {
    
    func didCreateTracker(title: String, weekdays: [Weekday], emoji: String, colorHex: String, toCategory: String) {
        viewModel.addNewTracker(
            title: title,
            weekdays: weekdays,
            emoji: emoji,
            colorHex: colorHex,
            currentDate: datePicker.date,
            toCategory: toCategory
        )
    }
    
    func didUpdateTracker(_ tracker: Tracker, newTitle: String, weekdays: [Weekday], emoji: String, colorHex: String, newCategory: String) {
        viewModel.updateTracker(tracker, newTitle: newTitle, weekdays: weekdays, emoji: emoji, colorHex: colorHex, newCategory: newCategory, currentDate: datePicker.date)
    }
}

// MARK: - UISearchResultsUpdating
extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        applyCurrentFilters()
    }
}

// MARK: - UISearchControllerDelegate
extension TrackersViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        navigationController?.navigationBar.sizeToFit()
    }
}

// MARK: - FiltersViewControllerDelegate
extension TrackersViewController: FiltersViewControllerDelegate {
    func didSelectFilter(_ filter: TrackerFilter) {
        selectedFilter = filter
        
        if filter == .today {
            datePicker.date = Date()
        }
        
        applyCurrentFilters()
    }
}
