//
//  SelectableItemCell.swift
//  Tracker
//
//  Created by Мамытов Руслан on 17.08.2026.
//

import UIKit

final class SelectableItemCell: UICollectionViewCell {
    static let identifier = "SelectableItem"
    
    private let bgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.font = .systemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    
    private let colorCircleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bgView)
        bgView.addSubview(emojiLabel)
        bgView.addSubview(colorCircleView)
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        colorCircleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            emojiLabel.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            
            colorCircleView.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            colorCircleView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            colorCircleView.widthAnchor.constraint(equalToConstant: 40),
            colorCircleView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    func configure(withEmoji emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        emojiLabel.isHidden = false
        colorCircleView.isHidden = true
        bgView.backgroundColor = isSelected ? .YPColors.gray : .clear
    }
    
    func configure(withColor color: UIColor, isSelected: Bool) {
        colorCircleView.backgroundColor = color
        colorCircleView.isHidden = false
        emojiLabel.isHidden = true
        bgView.backgroundColor = isSelected ? .YPColors.gray : .clear
    }
}
