//
//  Tracker.swift
//  Tracker
//
//  Created by Мамытов Руслан on 21.07.2026.
//
import Foundation

struct Tracker {
    let id = UUID()
    let name: String
    let emoji: String
    let colorName: TrackerColor
    let timetable: [Weekday]
}
