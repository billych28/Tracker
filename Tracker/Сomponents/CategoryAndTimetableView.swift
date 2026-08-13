//
//  CategoryAndTimetable.swift
//  Tracker
//
//  Created by Мамытов Руслан on 12.08.2026.
//
import UIKit

final class CategoryAndTimetableView: UIView {
    
    var onTimetableTap: (() -> Void)?
    
    let categoryRow = ItemRowView(title: "Категория")
    let timetableRow = ItemRowView(title: "Расписание")
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.backgroundColor = UIColor(resource: .YPColors.background)
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
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    private func setupView() {
        stackView.addArrangedSubview(categoryRow)
        stackView.addArrangedSubview(timetableRow)
        
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
    
    private func setupActions() {
        let timetableGesture = UITapGestureRecognizer(target: self, action: #selector(timetableRowTapped))
        timetableRow.addGestureRecognizer(timetableGesture)
        timetableRow.isUserInteractionEnabled = true
    }
    
    private func createItemRow(title: String) -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = UIColor(resource: .black)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = title
        descriptionLabel.font = .systemFont(ofSize: 17, weight: .regular)
        descriptionLabel.textColor = UIColor(resource: .YPColors.gray)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let chevron = UIImageView()
        chevron.image = UIImage(resource: .chevronIcon)
        chevron.tintColor = .tertiaryLabel
        chevron.contentMode = .scaleAspectFit
        chevron.translatesAutoresizingMaskIntoConstraints = false
        
        row.addSubview(titleLabel)
        row.addSubview(descriptionLabel)
        row.addSubview(chevron)
        
        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: 75),
            
            titleLabel.topAnchor.constraint(equalTo: row.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            chevron.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -16),
            chevron.centerYAnchor.constraint(equalTo: row.centerYAnchor),
        ])
        
        return row
    }
    
    @objc private func timetableRowTapped() {
        onTimetableTap?()
    }
}
