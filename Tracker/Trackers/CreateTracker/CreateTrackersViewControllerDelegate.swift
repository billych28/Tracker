//
//  CreateTrackersViewControllerDelegate.swift
//  Tracker
//
//  Created by Мамытов Руслан on 10.08.2026.
//

protocol CreateTrackersViewControllerDelegate: AnyObject {
    func didCreateTracker(title: String, weekdays: [Weekday])
}
