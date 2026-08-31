//
//  StatisticCardView.swift
//  Tracker
//
//  Created by Мамытов Руслан on 27.08.2026.
//
import UIKit

final class StatisticCardView: UIView {
    
    // MARK: - Private properties
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor(resource: .YPColors.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(resource: .YPColors.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let gradientLayer = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()
    
    // MARK: - Initializer
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupView()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Public methods
    func setValue(_ value: Int) {
        valueLabel.text = "\(value)"
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
        
        let rect = bounds.insetBy(dx: 0.5, dy: 0.5)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 16)
        
        shapeLayer.path = path.cgPath
        shapeLayer.frame = bounds
    }
    
    // MARK: - Private methods
    private func setupView() {
        backgroundColor = .clear
        layer.cornerRadius = 16
        clipsToBounds = true
        
        addSubview(valueLabel)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 7),
            titleLabel.leadingAnchor.constraint(equalTo: valueLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: valueLabel.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
        
        setupGradientBorder()
    }
    
    private func setupGradientBorder() {
        gradientLayer.colors = [
            UIColor(resource: .YPColors.selection1).cgColor,
            UIColor(resource: .YPColors.selection9).cgColor,
            UIColor(resource: .YPColors.selection3).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        shapeLayer.lineWidth = 1.0
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        gradientLayer.mask = shapeLayer
        layer.addSublayer(gradientLayer)
    }
}
