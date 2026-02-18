//
//  PowerCompactProgressText.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 23.01.2026.
//

import SwiftUI

struct PowerCompactProgressText: View {
    let state: PowerLiveActivityAttributes.ContentState
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text("\(state.powerPercent ?? 0)")
                .foregroundStyle(.white)
                .font(.system(size: 20, weight: .bold))

            Spacer().frame(width: 2)

            Text("%")
                .foregroundStyle(Color.white.opacity(0.8))
                .font(.system(size: 16, weight: .semibold))
        }
    }
}
