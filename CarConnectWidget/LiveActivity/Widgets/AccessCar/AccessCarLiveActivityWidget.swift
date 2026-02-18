//
//  AccessCarLiveActivityWidget.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 17.01.2026.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct AccessCarLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AccessCarLiveActivityAttributes.self) { context in
            let view = AccessCarLockScreenView(context: context)
                .activitySystemActionForegroundColor(.white)
            
            if #available(iOS 26.0, *) {
                view.activityBackgroundTint(.clear)
            } else {
                view.activityBackgroundTint(.black)
            }
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(context.state.vehicleMark) \(context.state.vehicleModel)")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white)
                            .lineLimit(1)

                        Text("LiveActivity.AccessCar.SubTitle".localized)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.white.opacity(0.8))
                            .lineLimit(1)
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                }

                DynamicIslandExpandedRegion(.trailing) {
                    HStack(spacing: 8) {
                        Link(destination: AccessCarDeepLink.url(action: .lock, vehicleId: context.attributes.vehicleId)) {
                            AccessCarActionMini(
                                iconAssetName: "AccessCar.Lock",
                                background: Color(red: 1.0, green: 0.23, blue: 0.19)
                            )
                        }

                        Link(destination: AccessCarDeepLink.url(action: .unlock, vehicleId: context.attributes.vehicleId)) {
                            AccessCarActionMini(
                                iconAssetName: "AccessCar.Unlock",
                                background: Color(red: 0.20, green: 0.78, blue: 0.35)
                            )
                        }
                    }
                }
            } compactLeading: {
                Image("AccessCar.Key")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)
            } compactTrailing: {
                Text("\(context.state.vehicleMark)")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white)
                    .lineLimit(1)
            } minimal: {
                Image("AccessCar.Key")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)
            }
        }
    }
}
