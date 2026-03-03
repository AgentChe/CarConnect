//
//  Collection+Extension.swift
//  Soccer
//
//  Created by Андрей Чернышев on 15.07.2022.
//

import Foundation

extension Swift.Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension RandomAccessCollection {
    func deterministicElement(seed: String) -> Element? {
        guard !isEmpty else { return nil }
        
        let h = fnv1a64(seed)
        let offset = Int(h % UInt64(count))
        
        return self[safe: index(startIndex, offsetBy: offset)]
    }
    
    private func fnv1a64(_ string: String) -> UInt64 {
        let prime: UInt64 = 1099511628211
        var hash: UInt64 = 14695981039346656037
        for b in string.utf8 {
            hash ^= UInt64(b)
            hash &*= prime
        }
        return hash
    }
}

extension RandomAccessCollection {
    func dailyElement(date: Date, salt: String, calendar: Calendar = .current) -> Element? {
        let day = dayNumber(for: date, calendar: calendar)
        return deterministicElement(seed: "\(salt)#\(day)")
    }
    
    private func dayNumber(for date: Date, calendar: Calendar) -> Int {
        let start = calendar.startOfDay(for: date)
        return Int(start.timeIntervalSinceReferenceDate / 86_400.0)
    }
}
