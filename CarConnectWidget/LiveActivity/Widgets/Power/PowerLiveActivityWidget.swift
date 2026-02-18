//
//  PowerLiveActivityWidget.swift
//  Runner
//
//  Created by Андрей Чернышев on 17.01.2026.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PowerLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PowerLiveActivityAttributes.self) { context in
            let view = PowerLockScreenView(context: context)
                .activitySystemActionForegroundColor(.white)
            
            if #available(iOS 26.0, *) {
                view.activityBackgroundTint(.clear)
            } else {
                view.activityBackgroundTint(.black)
            }
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    PowerDisplayIslandLeading(state: context.state)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    PowerProgressExpanded(state: context.state)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            } compactLeading: {
                PowerCompactProgressText(state: context.state)
            } compactTrailing: {
                PowerCompactIconView(state: context.state)
            } minimal: {
                PowerCompactIconView(state: context.state)
            }
        }
    }
}
