//
//  AccessCarLockScreenView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 19.01.2026.
//

import WidgetKit
import SwiftUI

struct AccessCarLockScreenView: View {
    let context: ActivityViewContext<AccessCarLiveActivityAttributes>

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header
            actions
        }
        .padding(16)
    }
}

// MARK: Private
private extension AccessCarLockScreenView {
    var header: some View {
        HStack(alignment: .center, spacing: 12) {
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

    var actions: some View {
        HStack(spacing: 12) {
            Link(destination: AccessCarDeepLink.url(action: .lock, vehicleId: context.attributes.vehicleId)) {
                AccessCarActionPill(
                    iconAssetName: "AccessCar.Lock",
                    titleKey: "LiveActivity.AccessCar.Lock".localized,
                    background: Color(red: 1.0, green: 0.23, blue: 0.19)
                )
            }

            Link(destination: AccessCarDeepLink.url(action: .unlock, vehicleId: context.attributes.vehicleId)) {
                AccessCarActionPill(
                    iconAssetName: "AccessCar.Unlock",
                    titleKey: "LiveActivity.AccessCar.Unlock".localized,
                    background: Color(red: 0.20, green: 0.78, blue: 0.35)
                )
            }
        }
    }
}
