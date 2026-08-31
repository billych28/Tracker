//
//  TimetableViewControllerDelegate.swift
//  Tracker
//
//  Created by Мамытов Руслан on 12.08.2026.
//

protocol TimetableViewControllerDelegate: AnyObject {
    func dateSelected(didSelectWeekdays weekdays: [Weekday])
}
