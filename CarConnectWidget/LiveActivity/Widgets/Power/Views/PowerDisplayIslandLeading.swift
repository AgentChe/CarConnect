//
//  PowerDisplayIslandLeading.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 23.01.2026.
//

import SwiftUI

struct PowerDisplayIslandLeading: View {
    let state: PowerLiveActivityAttributes.ContentState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(state.vehicleMark) \(state.vehicleModel)")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white)
                .lineLimit(1)
            
            HStack(spacing: 8) {
                Text(state.isElectric ? "LiveActivity.Power.Battery.SubTitle".localized : "LiveActivity.Power.Fuel.SubTitle".localized)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.8))
                    .lineLimit(1)
                
                PowerCompactIconView(state: state)
            }
        }
    }
}
