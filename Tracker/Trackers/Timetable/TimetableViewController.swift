//
//  TimetableViewController.swift
//  Tracker
//
//  Created by Мамытов Руслан on 12.08.2026.
//

import UIKit

enum TimetableViewControllerConstants {
    static let weekdayCellIdentifier = "WeekdayIdentifier"
}

final class TimetableViewController: UIViewController {
    
    weak var delegate: TimetableViewControllerDelegate?
    
    private let week: [Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    private var selectedWeekdays: Set<Weekday> = []
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let submitButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = NSLocalizedString("done_action_title", comment: "Done button title")
        config.baseForegroundColor = .YPColors.white
        config.baseBackgroundColor = .YPColors.black
        config.background.cornerRadius = 16
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        title = NSLocalizedString("timetable_title", comment: "Title for timetable screen")
        view.backgroundColor = .YPColors.white
        
        tableView.register(WeekdayCell.self, forCellReuseIdentifier: TimetableViewControllerConstants.weekdayCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        let submitAction = UIAction { [weak self] _ in
            guard let self else { return }
            
            delegate?.dateSelected(didSelectWeekdays: Array(selectedWeekdays))
            dismiss(animated: true)
        }
        
        submitButton.addAction(submitAction, for: .touchUpInside)
        
        view.addSubview(tableView)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -40),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            submitButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}


extension TimetableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        week.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimetableViewControllerConstants.weekdayCellIdentifier) as? WeekdayCell else {
            return UITableViewCell()
        }
        
        let weekday = week[indexPath.row]
        let isSelected = selectedWeekdays.contains(weekday)
        let dayName = Calendar.current.standaloneWeekdaySymbols[weekday.rawValue - 1].capitalized
        
        cell.configure(name: dayName, isSelected: isSelected) { [weak self] isOn in
            if isOn {
                self?.selectedWeekdays.insert(weekday)
            } else {
                self?.selectedWeekdays.remove(weekday)
            }
        }
        
        return cell
    }
}

extension TimetableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
