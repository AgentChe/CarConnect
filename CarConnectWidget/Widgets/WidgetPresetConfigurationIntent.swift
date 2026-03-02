//
//  WidgetPresetConfigurationIntent.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 02.03.2026.
//

import AppIntents

struct WidgetPresetConfigurationIntent: AppIntent, WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select preset" 

    @Parameter(title: "Preset")
    var preset: WidgetPresetEntity?
}
