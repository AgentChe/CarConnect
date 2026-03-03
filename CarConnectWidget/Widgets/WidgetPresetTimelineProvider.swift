//
//  WidgetPresetTimelineProvider.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 02.03.2026.
//

import WidgetKit
import AppIntents

struct WidgetPresetTimelineEntry: TimelineEntry {
    let date: Date
    let model: WidgetPreset?
}

struct WidgetPresetTimelineProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> WidgetPresetTimelineEntry {
        WidgetPresetTimelineEntry(date: .now, model: nil)
    }

    func snapshot(for configuration: WidgetPresetConfigurationIntent, in context: Context) async -> WidgetPresetTimelineEntry {
        WidgetPresetTimelineEntry(date: .now, model: configuration.preset?.preset)
    }

    func timeline(for configuration: WidgetPresetConfigurationIntent, in context: Context) async -> Timeline<WidgetPresetTimelineEntry> {
        let entry = WidgetPresetTimelineEntry(date: .now, model: configuration.preset?.preset)
        return Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(60 * 30)))
    }
}

// TODO:
// 1. обновление text quote каждый 24 часа
// 2. Saved - количество
// 3. Widget presets - all tab
// 5. Saved - hepler cell
