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
    
    private let textField: UITextField = {
        let textField = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))

        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.backgroundColor = UIColor(resource: .background)
        textField.clearButtonMode = .whileEditing
        textField.placeholder = "Введите название трекера"
        textField.borderStyle = .none
        textField.layer.cornerRadius = 16
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
        config.baseForegroundColor = UIColor(resource: .red)
        config.baseBackgroundColor = .clear
        config.background.strokeColor = UIColor(resource: .red)
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
        config.baseBackgroundColor = UIColor(resource: .gray)
        config.background.cornerRadius = 16
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
        setupUI()
        setupButtons()
    }
    
    private func setupScreen() {
        self.title = "Новая привычка"
        view.backgroundColor = .systemBackground
    }
    
    private func setupUI() {
        view.addSubview(textField)
        view.addSubview(parameterSectionView)
        view.addSubview(buttonsStackView)
        
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
            delegate?.createTrackerTap(title: textField.text ?? "")
            dismiss(animated: true)
        }
        cancelButton.addAction(cancelAction, for: .touchUpInside)
        submitButton.addAction(submitAction, for: .touchUpInside)
    }
}
