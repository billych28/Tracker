//
//  WeekdayArrayTransformer.swift
//  Tracker
//
//  Created by Мамытов Руслан on 17.08.2026.
//

import Foundation
import Logging

final class WeekdayArrayTransformer: ValueTransformer {
    static let name = NSValueTransformerName(rawValue: String(describing: WeekdayArrayTransformer.self))
    
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let weekdays = value as? [Weekday] else { return nil }
        do {
            let data = try JSONEncoder().encode(weekdays)
            return data
        } catch {
            AppDelegate.logger.error("Couldn't encode weekdays", metadata: ["view": "WeekdayArrayTransformer", "error": "\(error)"])
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            let weekdays = try JSONDecoder().decode([Weekday].self, from: data)
            return weekdays
        } catch {
            AppDelegate.logger.error("Couldn't decode weekdays", metadata: ["view": "WeekdayArrayTransformer", "error": "\(error)"])
            return nil
        }
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(WeekdayArrayTransformer(), forName: name)
    }
}
