//
//  CategoryAndTimetable.swift
//  Tracker
//
//  Created by Мамытов Руслан on 12.08.2026.
//
import UIKit

final class CategoryAndTimetableView: UIView {
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.backgroundColor = UIColor(resource: .background)
        stack.layer.cornerRadius = 16
        stack.clipsToBounds = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    private func setupView() {
        let category = createItemRow(title: "Категория")
        let timetable = createItemRow(title: "Расписание")
        
        stackView.addArrangedSubview(category)
        stackView.addArrangedSubview(timetable)
        
        addSubview(stackView)
        addSubview(separator)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            separator.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -24),
            separator.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
        ])
    }
    
    private func createItemRow(title: String) -> UIView {
        let row = UIView()
        
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let chevron = UIImageView()
        chevron.image = UIImage(resource: .chevronIcon)
        chevron.tintColor = .tertiaryLabel
        chevron.contentMode = .scaleAspectFit
        chevron.translatesAutoresizingMaskIntoConstraints = false
        
        row.addSubview(label)
        row.addSubview(chevron)
        
        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: 75),
            
            label.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            
            chevron.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -16),
            chevron.centerYAnchor.constraint(equalTo: row.centerYAnchor),
        ])
        
        return row
    }
}
