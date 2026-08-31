//
//  FiltersViewControllerDelegate.swift
//  Tracker
//
//  Created by Мамытов Руслан on 27.08.2026.
//
import UIKit

protocol FiltersViewControllerDelegate: AnyObject {
    func didSelectFilter(_ filter: TrackerFilter)
}

final class FiltersViewController: UIViewController {
    static let filterCellIdentifier = "FilterCell"
    
    weak var delegate: FiltersViewControllerDelegate?
    private let currentSelectedFilter: TrackerFilter
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .clear
        table.rowHeight = 75
        table.isScrollEnabled = false
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    init(currentFilter: TrackerFilter) {
        self.currentSelectedFilter = currentFilter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    
    private func setupScreen() {
        title = NSLocalizedString("filters_button_title", comment: "Filters title")
        view.backgroundColor = .YPColors.white
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.filterCellIdentifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension FiltersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TrackerFilter.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.filterCellIdentifier, for: indexPath)
        let filter = TrackerFilter.allCases[indexPath.row]
        
        cell.textLabel?.text = filter.title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.backgroundColor = .YPColors.background
        cell.selectionStyle = .none
        
        if filter == currentSelectedFilter && filter != .all && filter != .today {
            cell.accessoryType = .checkmark
            cell.tintColor = .YPColors.blue
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFilter = TrackerFilter.allCases[indexPath.row]
        delegate?.didSelectFilter(selectedFilter)
        dismiss(animated: true)
    }
}
