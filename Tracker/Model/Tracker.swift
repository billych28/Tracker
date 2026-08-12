//
//  Tracker.swift
//  Tracker
//
//  Created by Мамытов Руслан on 21.07.2026.
//

struct Tracker {
    let id: String
    let name: String
    let emoji: String
    let timetable: [Weekday]
}

enum Weekday: Int {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}
