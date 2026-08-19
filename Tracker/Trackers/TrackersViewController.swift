//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Мамытов Руслан on 16.07.2026.
//

import UIKit

final class TrackersViewController: UIViewController, UISearchResultsUpdating {
    
    // MARK: - Public properties
    let datePicker = UIDatePicker()
    let collectionViewParams = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 8)
    var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var viewModel: TrackersViewModel!
    
    // MARK: Private properties
    private let searchController = UISearchController(searchResultsController: nil)
    private var emptyView: EmptyView = {
        let view = EmptyView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        bindViewModel()
        setupNavBar()
        setupDatePicker()
        setupCollectionView()
        setupEmptyView()
        updateDataFilter()
    }
    
    // MARK: - Public methods
    func configure(with dataProvider: TrackersDataProvider) {
        self.viewModel = TrackersViewModel(dataProvider: dataProvider)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // TODO: реализация будет в 17 спринте
    }
    
    // MARK: - Private methods
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.onDataUpdated = { [weak self] _ in
            guard let self else { return }
            
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.reloadData()
        }
        
        viewModel.onEmptyStateChanged = { [weak self] isEmpty in
            guard let self else { return }
            
            emptyView.isHidden = !isEmpty
            collectionView.isHidden = isEmpty
        }
    }
    
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
        present(navController, animated: true)
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.maximumDate = Date()
        
        let changeDateAction = UIAction { [weak self] action in
            guard let self else { return }
            updateDataFilter()
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
    }
    
    private func setupEmptyView() {
        view.addSubview(emptyView)
        
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    private func updateDataFilter() {
        viewModel.filterTrackers(by: datePicker.date)
    }
}

// MARK: - CreateTrackerViewControllerDelegate
extension TrackersViewController: CreateTrackersViewControllerDelegate {
    func didCreateTracker(title: String, weekdays: [Weekday], emoji: String, colorHex: String) {
        viewModel.addNewTracker(
            title: title,
            weekdays: weekdays,
            emoji: emoji,
            colorHex: colorHex,
            currentDate: datePicker.date
        )
    }
}
