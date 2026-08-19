//
//  CategoryHeaderView.swift
//  Tracker
//
//  Created by Мамытов Руслан on 22.07.2026.
//

import UIKit

final class HeaderReusableView: UICollectionReusableView {
    static let identifier = "CategoryHeaderView"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28)
        ])  
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
}
