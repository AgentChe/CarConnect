//
//  PowerCompactIconView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 23.01.2026.
//

import SwiftUI

struct PowerCompactIconView: View {
    let state: PowerLiveActivityAttributes.ContentState
    
    var body: some View {
        let type = state.isElectric ? "Battery" : "Fuel"
        let state = state.isDangerLevel ? "Danger" : (state.isWarningLevel ? "Warning" : "Normal")
        let name = "Power.\(type).Small.\(state)"
        
        Image(name)
            .scaledToFit()
            .frame(width: 20, height: 20)
    }
}
