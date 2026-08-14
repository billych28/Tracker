//
//  DesignSystemColor.swift
//  Tracker
//
//  Created by Мамытов Руслан on 13.08.2026.
//
import UIKit

enum TrackerColor: String, Codable {
    case green = "YPColors/Green"
    case red = "YPColors/Red"
    
    var uiColor: UIColor {
        return UIColor(named: self.rawValue) ?? .systemBackground
    }
}
