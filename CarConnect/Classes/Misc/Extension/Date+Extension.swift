//
//  Date+Extension.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.05.2026.
//

import Foundation

extension Date {
    static func isDay(_ date: Date) -> Bool {
        let hour = Calendar.current.component(.hour, from: date)
        return (6..<18).contains(hour)
    }
}
