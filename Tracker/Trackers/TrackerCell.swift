//
//  TrackerCell.swift
//  Tracker
//
//  Created by Мамытов Руслан on 21.07.2026.
//

import UIKit

final class TrackerCell: UICollectionViewCell {
    
    weak var delegate: TrackerCellDelegate?
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .green)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(resource: .border).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emojiContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.3)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "0 дней"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let completeButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 12)
        
        configuration.baseBackgroundColor = UIColor(resource: .green)
        configuration.background.cornerRadius = 16
        configuration.imageColorTransformer = UIConfigurationColorTransformer { _ in
            return .white
        }
        configuration.preferredSymbolConfigurationForImage = symbolConfig
        
        let button = UIButton(configuration: configuration)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupCompleteButton()
    }
    
    func setIsCompleted(with count: Int, isCompleted: Bool) {
        guard var config = completeButton.configuration else { return }
        countLabel.text = "\(count) дней"
        
        if isCompleted {
            completeButton.setImage(UIImage(resource: .doneIcon), for: .normal)
            config.background.backgroundColor = UIColor(resource: .green).withAlphaComponent(0.3)
        } else {
            completeButton.setImage(UIImage(systemName: "plus"), for: .normal)
            config.background.backgroundColor = UIColor(resource: .green)
        }
        
        completeButton.configuration = config
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(emojiContainer)
        emojiContainer.addSubview(emojiLabel)
        containerView.addSubview(titleLabel)
        
        contentView.addSubview(countLabel)
        contentView.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emojiContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            emojiContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            emojiContainer.widthAnchor.constraint(equalToConstant: 24),
            emojiContainer.heightAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiContainer.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiContainer.centerYAnchor),
            
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: emojiContainer.bottomAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            countLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 16),
            countLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            countLabel.trailingAnchor.constraint(equalTo: completeButton.leadingAnchor, constant: 8),
            
            completeButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            completeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            completeButton.widthAnchor.constraint(equalToConstant: 34),
            completeButton.heightAnchor.constraint(equalToConstant: 34),
        ])
    }
    
    private func setupCompleteButton() {
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            
            delegate?.didTapOnComplete(on: self)
        }
        completeButton.addAction(action, for: .touchUpInside)
    }
}
