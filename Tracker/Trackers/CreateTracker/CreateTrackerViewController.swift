//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Мамытов Руслан on 10.08.2026.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    
    weak var delegate: CreateTrackersViewControllerDelegate?
    
    private let trackerParamItems = ["Категория", "Расписание"]
    
    private let textField: TextFieldView = {
        let textFieldView = TextFieldView(frame: .zero, placeholder: "Введите название трекера", limit: 38)
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        return textFieldView
    }()
    
    private let parameterSectionView: CategoryAndTimetableView = {
        let section = CategoryAndTimetableView()
        section.translatesAutoresizingMaskIntoConstraints = false
        return section
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let cancelButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        config.title = "Отменить"
        config.baseForegroundColor = UIColor(resource: .YPColors.red)
        config.baseBackgroundColor = .clear
        config.background.strokeColor = UIColor(resource: .YPColors.red)
        config.background.strokeWidth = 1.0
        config.background.cornerRadius = 16
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let submitButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Создать"
        config.baseForegroundColor = .white
        config.baseBackgroundColor = UIColor(resource: .YPColors.gray)
        config.background.cornerRadius = 16
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var selectedWeekdays: [Weekday] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
        setupUI()
        setupButtons()
    }
    
    private func setupScreen() {
        title = "Новая привычка"
        view.backgroundColor = .systemBackground
    }
    
    private func setupUI() {
        view.addSubview(textField)
        view.addSubview(parameterSectionView)
        view.addSubview(buttonsStackView)
        
        parameterSectionView.onTimetableTap = { [weak self] in
            guard let self else { return }
            
            let timetableVC = TimetableViewController()
            let navController = UINavigationController(rootViewController: timetableVC)
            timetableVC.delegate = self
            
            present(navController, animated: true)
        }
        
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(submitButton)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            parameterSectionView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            parameterSectionView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            parameterSectionView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupButtons() {
        let cancelAction = UIAction { [weak self] _ in
            guard let self else { return }
            dismiss(animated: true)
        }
        let submitAction = UIAction { [weak self] _ in
            guard let self else { return }
            
            let title = textField.textField.text ?? ""
            delegate?.didCreateTracker(title: title, weekdays: selectedWeekdays)
            dismiss(animated: true)
        }
        cancelButton.addAction(cancelAction, for: .touchUpInside)
        submitButton.addAction(submitAction, for: .touchUpInside)
    }
}

// MARK: - TimetableViewControllerDelegate
extension CreateTrackerViewController: TimetableViewControllerDelegate {
    func dateSelected(_ picker: TimetableViewController, didSelectWeekdays weekdays: [Weekday]) {
        selectedWeekdays = weekdays
        let timetableDescription = selectedWeekdays.formatWeekdays()
        parameterSectionView.timetableRow.updateDescription(timetableDescription)
    }
}
