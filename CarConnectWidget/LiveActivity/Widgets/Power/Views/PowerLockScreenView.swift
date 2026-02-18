//
//  PowerLockScreenView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 23.01.2026.
//

import WidgetKit
import SwiftUI

struct PowerLockScreenView: View {
    let context: ActivityViewContext<PowerLiveActivityAttributes>

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header
            bottom
        }
        .padding(16)
    }
}

// MARK: Private
private extension PowerLockScreenView {
    var header: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(context.state.vehicleMark) \(context.state.vehicleModel)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Text(context.state.isElectric ? "LiveActivity.Power.Battery.SubTitle".localized : "LiveActivity.Power.Fuel.SubTitle".localized)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.8))
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            vehicleImageView
        }
    }
    
    var vehicleImageView: some View {
        Group {
            if let uiImage = cachedVehicleImage() {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                Image("Car.Placeholder")
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(width: 144, height: 60)
    }

    func cachedVehicleImage() -> UIImage? {
        guard let url = VehicleImageCacheManager.shared.cachedImageURL(
            vehicleId: context.attributes.vehicleId
        ) else { return nil }

        return UIImage(contentsOfFile: url.path)
    }
    
    var bottom: some View {
        HStack(alignment: .center, spacing: 0) {
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text("\(context.state.powerPercent ?? 0)")
                    .foregroundStyle(.white)
                    .font(.system(size: 32, weight: .bold))

                Spacer().frame(width: 6)

                Text("%")
                    .foregroundStyle(Color.white.opacity(0.8))
                    .font(.system(size: 20, weight: .semibold))
            }
            
            PowerProgressBar(
                value: context.state.powerPercent ?? 0,
                isWarningLevel: context.state.isWarningLevel,
                isDangerLevel: context.state.isDangerLevel
            )
            .padding(.horizontal, 14)
            .frame(maxWidth: .infinity)

            Image(context.state.isElectric ? "Power.Battery.Large" : "Power.Fuel.Large")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundStyle(.white)
        }
    }
}
