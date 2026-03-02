//
//  AmbitionDriveWidgetView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 02.03.2026.
//

import SwiftUI

struct QuoteAmbitionDriveWidgetView: View {
    let quote: WidgetTextQuoteAmbitionDrive
    let configuration: WidgetTextQuoteConfiguration

    private let baseSide: CGFloat = 343

    var body: some View {
        GeometryReader { geo in
            let side = min(geo.size.width, geo.size.height)
            let scale = side / baseSide

            ZStack {
                Image(quote.picture)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()

                LinearGradient(
                    stops: [
                        .init(color: Color(Appearance.color_2E2E2E.withAlphaComponent(0)), location: 0.0),
                        .init(color: Color(Appearance.color_272727.withAlphaComponent(0.74)), location: 0.58),
                        .init(color: Color(Appearance.color_242424), location: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10 * scale)
                        .stroke(Color(uiColor: Appearance.color_2C2F39), lineWidth: 1 * scale)
                )

                VStack(alignment: .leading, spacing: 0) {
                    Text("“")
                        .font(configuration.font.swiftUIFont(size: 74 * scale))
                        .foregroundStyle(Color(uiColor: configuration.textColor))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 21 * scale)
                        .padding(.leading, 21 * scale)

                    Spacer(minLength: 0)

                    Text(quote.text)
                        .font(configuration.font.swiftUIFont(size: 30 * scale))
                        .foregroundStyle(Color(uiColor: configuration.textColor))
                        .lineLimit(4)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 21 * scale)
                        .padding(.bottom, 21 * scale)

                    HStack(spacing: 16 * scale) {
                        Image(quote.picture)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 58 * scale, height: 58 * scale)
                            .clipShape(RoundedRectangle(cornerRadius: 12 * scale))

                        VStack(alignment: .leading, spacing: 0) {
                            Text(quote.authorName)
                                .font(configuration.font.swiftUIFont(size: 20 * scale))
                                .foregroundStyle(Color(uiColor: configuration.textColor))
                                .lineLimit(1)
                                .truncationMode(.tail)

                            Spacer(minLength: 0)

                            Text(quote.authorSocialRole)
                                .font(configuration.font.swiftUIFont(size: 20 * scale))
                                .foregroundStyle(Color(uiColor: configuration.textColor).opacity(0.4))
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        .frame(height: 58 * scale)
                    }
                    .padding(.horizontal, 21 * scale)
                    .padding(.bottom, 21 * scale)
                }
            }
            .background(Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 10 * scale))
        }
    }
}
