//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Мамытов Руслан on 10.08.2026.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    
    weak var delegate: CreateTrackersViewControllerDelegate?
    
    var selectedEmojiIndexPath: IndexPath?
    var selectedColorIndexPath: IndexPath?
    
    let columnsCount = 6
    let itemSpacing = 5
    let emojis: [String] = [
        "😀", "😂", "😍", "🥳", "😎", "🤔",
        "🐶", "🐱", "🦊", "🐼", "🐨", "🦁",
        "🍎", "🍌", "🍉", "🍓", "🍒", "🍑"
    ]
    let colors: [UIColor] = [
        .YPColors.selection1, .YPColors.selection2, .YPColors.selection3, .YPColors.selection4, .YPColors.selection5,
        .YPColors.selection6, .YPColors.selection7, .YPColors.selection8, .YPColors.selection9, .YPColors.selection10,
        .YPColors.selection11, .YPColors.selection12,.YPColors.selection13, .YPColors.selection14, .YPColors.selection15,
        .YPColors.selection16, .YPColors.selection17, .YPColors.selection18
    ]
    
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
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.register(SelectableItemCell.self, forCellWithReuseIdentifier: SelectableItemCell.identifier)
        cv.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
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
        parameterSectionView.categoryRow.updateDescription("iOS-разработка")
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupUI() {
        view.addSubview(textField)
        view.addSubview(parameterSectionView)
        view.addSubview(collectionView)
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
            
            parameterSectionView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 12),
            parameterSectionView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            parameterSectionView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: parameterSectionView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -16),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
            didTapSubmit()
        }
        cancelButton.addAction(cancelAction, for: .touchUpInside)
        submitButton.addAction(submitAction, for: .touchUpInside)
    }
    
    private func didTapSubmit() {
        guard
            validateTextField(),
            let emojiIndex = selectedEmojiIndexPath,
            let colorIndex = selectedColorIndexPath,
            let title = textField.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        else {
            return
        }
        
        let emoji = emojis[emojiIndex.row]
        let colorHex = UIColorMarshalling.hexString(from: colors[colorIndex.row])
        
        delegate?.didCreateTracker(title: title, weekdays: selectedWeekdays, emoji: emoji, colorHex: colorHex)
        dismiss(animated: true)
    }
    
    private func validateTextField() -> Bool {
        guard let text = textField.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
            textField.updateErrorLabel(description: "Заполните поле", isHidden: false)
            return false
        }
        
        textField.updateErrorLabel(description: "", isHidden: true)
        return true
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
