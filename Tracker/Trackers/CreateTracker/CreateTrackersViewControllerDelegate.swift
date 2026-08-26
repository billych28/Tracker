//
//  CreateTrackersViewControllerDelegate.swift
//  Tracker
//
//  Created by Мамытов Руслан on 10.08.2026.
//
import UIKit

protocol CreateTrackersViewControllerDelegate: AnyObject {
    func didCreateTracker(title: String, weekdays: [Weekday], emoji: String, colorHex: String, toCategory: String)
}
