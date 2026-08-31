//
//  ItemRowView.swift
//  Tracker
//
//  Created by Мамытов Руслан on 12.08.2026.
//
import UIKit

final class ItemRowView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(resource: .YPColors.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(resource: .YPColors.gray)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevron: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .chevronIcon)
        imageView.tintColor = .tertiaryLabel
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var titleCenterYConstraint: NSLayoutConstraint?
    private var titleTopConstraint: NSLayoutConstraint?
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    func updateDescription(_ text: String) {
        let isEmpty = text.isEmpty
        
        descriptionLabel.text = text
        descriptionLabel.isHidden = isEmpty
        
        titleCenterYConstraint?.isActive = isEmpty
        titleTopConstraint?.isActive = !isEmpty
    }
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(chevron)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 75),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            chevron.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chevron.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        titleCenterYConstraint = titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        titleTopConstraint = titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16)
        
        titleCenterYConstraint?.isActive = true
    }
}
