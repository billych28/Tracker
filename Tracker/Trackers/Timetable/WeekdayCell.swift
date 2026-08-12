//
//  WeekDayCell.swift
//  Tracker
//
//  Created by Мамытов Руслан on 12.08.2026.
//

import UIKit

final class WeekdayCell: UITableViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    private var toggleAction: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupToggle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        toggleAction = nil
    }
    
    func configure(name: String, isSelected: Bool, onToggle: @escaping (Bool) -> Void) {
        nameLabel.text = name
        toggle.isOn = isSelected
        toggleAction = onToggle
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, toggle])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupToggle() {
        let action = UIAction { [weak self] action in
            guard let self else { return }
            guard let sender = action.sender as? UISwitch else { return }
            toggleAction?(sender.isOn)
        }
        toggle.addAction(action, for: .valueChanged)
    }
    
}
