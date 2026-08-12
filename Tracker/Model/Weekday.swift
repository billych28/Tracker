//
//  Weekday.swift
//  Tracker
//
//  Created by Мамытов Руслан on 12.08.2026.
//
import Foundation

enum Weekday: Int {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var shortName: String {
        let symbols = Calendar.current.shortStandaloneWeekdaySymbols
        return symbols[self.rawValue - 1].capitalized
    }
}
