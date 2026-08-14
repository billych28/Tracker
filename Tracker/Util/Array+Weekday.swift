//
//  Array+Weekday.swift
//  Tracker
//
//  Created by Мамытов Руслан on 12.08.2026.
//

extension Array where Element == Weekday {
    func formatWeekdays() -> String {
        guard !self.isEmpty else {
            return "Расписание"
        }
        
        if self.count == 7 {
            return "Каждый день"
        }
        
        let sortedWeekdays = self.sorted { (day1, day2) -> Bool in
            let val1 = day1 == .sunday ? 8 : day1.rawValue
            let val2 = day2 == .sunday ? 8 : day2.rawValue
            return val1 < val2
        }
        
        return sortedWeekdays.map { $0.shortName }.joined(separator: ", ")
    }
}
