//
//  CreateCategoryViewController.swift
//  Tracker
//
//  Created by Мамытов Руслан on 20.08.2026.
//

import UIKit

final class CreateCategoryViewController: UIViewController {
    
    var onCategoryCreated: ((String) -> Void)?
    
    private let textField: TextFieldView = {
        let placeholder = NSLocalizedString("create_category_name_placeholder", comment: "Placeholder for category name text field")
        let textField = TextFieldView(frame: .zero, placeholder: placeholder, limit: 38)
        textField.textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let doneButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = NSLocalizedString("done_button_title", comment: "Create category button title")
        config.baseBackgroundColor = .YPColors.black
        config.baseForegroundColor = .YPColors.white
        
        let button = UIButton(configuration: config)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("create_category_title", comment: "Title for create category screen")
        view.backgroundColor = .YPColors.white
        
        setupUI()
        setupTextField()
        setupButton()
    }
    
    // MARK: - Public methods
    func setInitialText(with text: String) {
        textField.textField.text = text
    }
    
    // MARK: - Private methods
    private func setupUI() {
        view.addSubview(textField)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupTextField() {
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            
            let text = textField.textField.text ?? ""
            doneButton.isEnabled = !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        textField.textField.addAction(action, for: .editingChanged)
    }
    
    private func setupButton() {
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            didTapDone()
        }
        doneButton.addAction(action, for: .touchUpInside)
    }
    
    private func didTapDone() {
        guard let text = textField.textField.text else { return }
        onCategoryCreated?(text)
        dismiss(animated: true)
    }
}
