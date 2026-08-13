//
//  TextFieldView.swift
//  Tracker
//
//  Created by Мамытов Руслан on 12.08.2026.
//

import UIKit

final class TextFieldView: UIView {
    let textField: UITextField = {
        let textField = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.backgroundColor = UIColor(resource: .YPColors.background)
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .none
        textField.layer.cornerRadius = 16
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    let errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(resource: .YPColors.red)
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var maxLimit: Int = 10
    
    init(frame: CGRect, placeholder: String, limit: Int) {
        super.init(frame: frame)
        self.maxLimit = limit
        setupViews(placeholder: placeholder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    private func setupViews(placeholder: String) {
        backgroundColor = .systemBackground
        textField.delegate = self
        textField.placeholder = placeholder
        errorLabel.textColor = .systemRed
        errorLabel.isHidden = true
        
        let stack = UIStackView(arrangedSubviews: [textField, errorLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

// MARK: - UITextFieldDelegate
extension TextFieldView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        let isWithinLimit = updatedText.count <= maxLimit
        errorLabel.isHidden = isWithinLimit
        errorLabel.text = isWithinLimit ? "" : "Ограничение \(maxLimit) символов"
        
        return isWithinLimit
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        errorLabel.isHidden = true
        errorLabel.text = ""
        return true
    }
}
