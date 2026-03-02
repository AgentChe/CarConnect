//
//  QuoteLifeMeaningWidgetView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 02.03.2026.
//

import SwiftUI

struct QuoteLifeMeaningWidgetView: View {
    let quote: WidgetTextQuoteLifeMeaning
    let configuration: WidgetTextQuoteConfiguration

    private let baseSide: CGFloat = 343

    var body: some View {
        GeometryReader { geo in
            let side = min(geo.size.width, geo.size.height)
            let scale = side / baseSide

            ZStack {
                LinearGradient(
                    stops: [
                        .init(color: Color(uiColor: Appearance.color_4B4F5B), location: 0.0),
                        .init(color: Color(uiColor: Appearance.color_2C2F39), location: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10 * scale)
                        .stroke(Color(uiColor: Appearance.color_2C2F39), lineWidth: 1 * scale)
                )

                ZStack {
                    Text(quote.text)
                        .font(configuration.font.swiftUIFont(size: 30 * scale))
                        .foregroundStyle(Color(uiColor: configuration.textColor))
                        .lineLimit(4)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(.horizontal, 21 * scale)
                        .padding(.vertical, 60 * scale)

                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Image("TextQuote.LifeMeaning.QuotationMark")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 48 * scale, height: 48 * scale)
                                .padding(.top, 42 * scale)
                                .padding(.leading, 21 * scale)

                            Spacer(minLength: 0)
                        }

                        Spacer(minLength: 0)

                        HStack(spacing: 0) {
                            Text(quote.authorName)
                                .font(configuration.font.swiftUIFont(size: 20 * scale))
                                .foregroundStyle(Color(uiColor: configuration.textColor).opacity(0.4))
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .padding(.leading, 21 * scale)
                                .padding(.bottom, 42 * scale)

                            Spacer(minLength: 0)
                        }
                    }
                }
            }
            .background(Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 10 * scale))
        }
    }
}
