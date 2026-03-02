//
//  CarConnectWidgetBundle.swift
//  CarConnectWidget
//
//  Created by Андрей Чернышев on 12.01.2026.
//

import WidgetKit
import SwiftUI

@main
struct CarConnectWidgetBundle: WidgetBundle {
    var body: some Widget {
        AccessCarLiveActivityWidget()
        PowerLiveActivityWidget()
        TirePressureLiveActivityWidget()
        
        WidgetWithPresets()
    }
}
