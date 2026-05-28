//
//  TirePressureLiveActivityWidget.swift
//  Runner
//
//  Created by Андрей Чернышев on 17.01.2026.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TirePressureLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        let isMetric = SettingsEnvironment.shared.distanceUnit == .metric
        
        return ActivityConfiguration(for: TirePressureLiveActivityAttributes.self) { context in
            let view = TirePressureLockScreenView(context: context, isMetric: isMetric)
                .activitySystemActionForegroundColor(.white)
            
            if #available(iOS 26.0, *) {
                view.activityBackgroundTint(.clear) 
            } else {
                view.activityBackgroundTint(.black)
            }
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(LocalizedStringKey("TirePressure"))
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color.white)
                        
                        (Text("(") + Text(isMetric ? "LiveActivity.kpa".localized : "LiveActivity.psi".localized) + Text(")"))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.white.opacity(0.8))
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    TirePressureDinamicIslandTrailingView(context: context, isMetric: isMetric)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
            compactLeading: {
                EmptyView()
            }
            compactTrailing: {
                Image("MinimalLogo")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)
            }
            minimal: {
                Image("MinimalLogo")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)
            }
        }
    }
}
