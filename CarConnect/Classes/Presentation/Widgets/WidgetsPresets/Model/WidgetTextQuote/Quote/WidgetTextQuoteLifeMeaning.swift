//
//  WidgetTextQuoteLifeMeaning.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

struct WidgetTextQuoteLifeMeaning: WidgetTextQuote {
    let text: String
    let authorName: String
    
    static func templates() -> [WidgetTextQuoteLifeMeaning] {
        [
            WidgetTextQuoteLifeMeaning(
                text: "Be yourself; everyone else is already taken",
                authorName: "- Oscar Wilde"
            ),
            WidgetTextQuoteLifeMeaning(
                text: "Happiness depends upon ourselves",
                authorName: "- Aristotle"
            ),
            WidgetTextQuoteLifeMeaning(
                text: "The purpose of our lives is to be happy",
                authorName: "- Dalai Lama"
            ),
            WidgetTextQuoteLifeMeaning(
                text: "No one can make you feel inferior without your consent",
                authorName: "- Eleanor Roosevelt"
            ),
            WidgetTextQuoteLifeMeaning(
                text: "Life is what happens when you’re busy making other plans",
                authorName: "- John Lennon"
            ),
            WidgetTextQuoteLifeMeaning(
                text: "Turn your wounds into wisdom",
                authorName: "- Oprah Winfrey"
            ),
            WidgetTextQuoteLifeMeaning(
                text: "If you judge people, you have no time to love them",
                authorName: "- Mother Teresa"
            )
        ]
    }
}
