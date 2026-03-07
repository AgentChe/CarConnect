//
//  WidgetCalendarStyle.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.03.2026.
//

enum WidgetCalendarStyle: Codable, Hashable {
    // Маленький календарь-месяц (сеткой), подсвечен выбранный день
    case monthGrid

    // Большой день + большой номер (Friday / 26)
    case weekdayAndDayNumberLarge

    // Комбо: большой номер + рядом месяц-сетка (15 / Wed / August + grid)
    case dayNumberWithMonthGrid

    // Большой номер + сокращение месяца (Tue Sep / 23)
    case monthAbbrevAndDayNumberLarge

    // Текстовая дата (Jun 9 / Wednesday)
    case monthDayAndWeekdayText

    // Вертикальная/стековая дата (AUGUST / 21 / SUN)
    case stackedMonthDayWeekday
}
