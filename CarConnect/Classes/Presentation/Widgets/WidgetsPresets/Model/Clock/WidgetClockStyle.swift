//
//  WidgetClockStyle.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 25.03.2026.
//

import Foundation

enum WidgetClockStyle: Codable, Hashable {
    case digitalStacked        // 08 / 42
    case digitalMirror         // с отражением
    case digitalClassic        // обычные цифры 08:20
    case splitFlap             // перекидные карточки
    case calendarClock         // время + день месяца/недели
    case analogClock           // стрелочные часы
}
