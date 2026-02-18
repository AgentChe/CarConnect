//
//  AccessCarActionPill.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 19.01.2026.
//

import SwiftUI

struct AccessCarActionPill: View {
    let iconAssetName: String
    let titleKey: String
    let background: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(iconAssetName)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(.white)

            Text(LocalizedStringKey(titleKey))
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.white)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(background)
        .clipShape(Capsule())
    }
}

struct AccessCarActionMini: View {
    let iconAssetName: String
    let background: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(background)

            Image(iconAssetName)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(.white)
        }
        .frame(width: 46, height: 46)
    }
}
