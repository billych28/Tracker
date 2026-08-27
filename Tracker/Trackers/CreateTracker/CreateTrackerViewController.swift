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
    
    private let trackerParamItems = [
        NSLocalizedString("create_tracker_category_title", comment: "Title for category item"),
        NSLocalizedString("create_tracker_timetable_title", comment: "Title for timetable item"),
    ]
    private let completedCountLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textAlignment = .center
        label.textColor = .YPColors.black
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let textField: TextFieldView = {
        let placeholder = NSLocalizedString("create_tracker_name_placeholder", comment: "Placeholder for tracker name text field")
        let textFieldView = TextFieldView(frame: .zero, placeholder: placeholder, limit: 38)
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
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.register(SelectableItemCell.self, forCellWithReuseIdentifier: SelectableItemCell.identifier)
        collection.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
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
        config.title = NSLocalizedString("create_tracker_cancel_button_title", comment: "Cancel button title")
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
        config.title = NSLocalizedString("create_tracker_button_title", comment: "Create tracker button")
        config.baseForegroundColor = .YPColors.white
        config.baseBackgroundColor = .YPColors.gray
        config.background.cornerRadius = 16
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var selectedCategory: String = ""
    private var selectedWeekdays: [Weekday] = []
    private var editingTracker: Tracker?
    private var isEditMode: Bool { editingTracker != nil }
    
    convenience init(editingTracker: Tracker, categoryTitle: String, completionCount: Int) {
        self.init(nibName: nil, bundle: nil)
        self.editingTracker = editingTracker
        self.selectedCategory = categoryTitle
        self.selectedWeekdays = editingTracker.timetable
        self.completedCountLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("trackers_cell_days_count", comment: "Number of completed days"),
            completionCount
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
        setupUI()
        setupButtons()
    }
    
    private func setupScreen() {
        if isEditMode, let tracker = editingTracker {
            editingModeSetup(tracker)
        } else {
            creationModeSetup()
        }
        view.backgroundColor = .YPColors.white
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func editingModeSetup(_ tracker: Tracker) {
        title = NSLocalizedString("edit_tracker_title", comment: "Edit tracker title")
        let submitButtonTitle = NSLocalizedString("edit_tracker_save_button_title", comment: "Save button title")
        submitButton.setTitle(submitButtonTitle, for: .normal)
        
        completedCountLabel.isHidden = false
        
        textField.textField.text = tracker.name
        
        parameterSectionView.categoryRow.updateDescription(selectedCategory)
        
        let timetableDescription = selectedWeekdays.formatWeekdays()
        parameterSectionView.timetableRow.updateDescription(timetableDescription)
        
        if let emojiIndex = emojis.firstIndex(of: tracker.emoji) {
            selectedEmojiIndexPath = IndexPath(item: emojiIndex, section: 0)
        }
        
        if let colorIndex = colors.firstIndex(where: {
            UIColorMarshalling.hexString(from: $0) == UIColorMarshalling.hexString(from: tracker.color)
        }) {
            selectedColorIndexPath = IndexPath(item: colorIndex, section: 1)
        }
    }
    
    private func creationModeSetup() {
        title = NSLocalizedString("create_tracker_title", comment: "Create tracker")
        let submitButtonTitle = NSLocalizedString("create_tracker_button_title", comment: "Create tracker button title")
        completedCountLabel.isHidden = true
        completedCountLabel.text = ""
        submitButton.setTitle(submitButtonTitle, for: .normal)
    }
    
    private func setupUI() {
        view.addSubview(completedCountLabel)
        view.addSubview(textField)
        view.addSubview(parameterSectionView)
        view.addSubview(collectionView)
        view.addSubview(buttonsStackView)
        
        parameterSectionView.onCategoryTap = { [weak self] in
            guard let self else { return }
            
            let categoriesViewModel = CategoriesViewModel(dataProvider: dataProvider)
            let categoriesVC = CategoriesViewController(viewModel: categoriesViewModel)
            let navController = UINavigationController(rootViewController: categoriesVC)
            categoriesVC.delegate = self
            
            present(navController, animated: true)
        }
        
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
            completedCountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            completedCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            completedCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            textField.topAnchor.constraint(equalTo: completedCountLabel.bottomAnchor, constant: 40),
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
            !selectedCategory.isEmpty,
            !selectedWeekdays.isEmpty,
            let emojiIndex = selectedEmojiIndexPath,
            let colorIndex = selectedColorIndexPath,
            let title = textField.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        else {
            return
        }
        
        let emoji = emojis[emojiIndex.row]
        let colorHex = UIColorMarshalling.hexString(from: colors[colorIndex.row])
        
        if isEditMode, let originalTracker = editingTracker {
            delegate?.didUpdateTracker(
                originalTracker,
                newTitle: title,
                weekdays: selectedWeekdays,
                emoji: emojis[emojiIndex.item],
                colorHex: colorHex,
                newCategory: selectedCategory
            )
        } else {
            delegate?.didCreateTracker(title: title, weekdays: selectedWeekdays, emoji: emoji, colorHex: colorHex, toCategory: selectedCategory)
        }
        
        dismiss(animated: true)
    }
    
    private func validateTextField() -> Bool {
        guard let text = textField.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
            let description = NSLocalizedString("create_tracker_text_field_error_description", comment: "Text Field error description")
            textField.updateErrorLabel(description: description, isHidden: false)
            return false
        }
        
        textField.updateErrorLabel(description: "", isHidden: true)
        return true
    }
}

extension CreateTrackerViewController: CategoryListViewControllerDelegate {
    func didSelectCategory(_ categoryName: String) {
        selectedCategory = categoryName
        parameterSectionView.categoryRow.updateDescription(categoryName)
    }
}

// MARK: - TimetableViewControllerDelegate
extension CreateTrackerViewController: TimetableViewControllerDelegate {
    func dateSelected(didSelectWeekdays weekdays: [Weekday]) {
        selectedWeekdays = weekdays
        let timetableDescription = selectedWeekdays.formatWeekdays()
        parameterSectionView.timetableRow.updateDescription(timetableDescription)
    }
}
