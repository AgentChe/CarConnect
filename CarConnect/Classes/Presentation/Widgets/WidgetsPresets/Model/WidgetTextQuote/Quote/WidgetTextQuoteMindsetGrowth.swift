//
//  WidgetTextQuoteMindsetGrowth.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

struct WidgetTextQuoteMindsetGrowth {
    let text: String
    let picture: String
    let authorName: String
    
    static func templates() -> [WidgetTextQuoteMindsetGrowth] {
        [
            WidgetTextQuoteMindsetGrowth(
                text: "The unexamined life is not worth living",
                picture: "TextQuote.MindsetGrowth.Socrates",
                authorName: "- Socrates"
            ),
            WidgetTextQuoteMindsetGrowth(
                text: "In the middle of difficulty lies opportunity",
                picture: "TextQuote.MindsetGrowth.AlbertEinstein",
                authorName: "- Albert Einstein"
            ),
            WidgetTextQuoteMindsetGrowth(
                text: "He who has a why to live can bear almost any how",
                picture: "TextQuote.MindsetGrowth.FriedrichNietzsche",
                authorName: "- Friedrich Nietzsche"
            ),
            WidgetTextQuoteMindsetGrowth(
                text: "Knowing yourself is the beginning of all wisdom",
                picture: "TextQuote.MindsetGrowth.Aristotle",
                authorName: "- Aristotle"
            ),
            WidgetTextQuoteMindsetGrowth(
                text: "We are what we repeatedly do. Excellence, then, is not an act but a habit",
                picture: "TextQuote.MindsetGrowth.WillDurant",
                authorName: "- Will Durant"
            ),
            WidgetTextQuoteMindsetGrowth(
                text: "Do what you can, with what you have, where you are",
                picture: "TextQuote.MindsetGrowth.TheodoreRoosevelt",
                authorName: "- Theodore Roosevelt"
            ),
            WidgetTextQuoteMindsetGrowth(
                text: "It is not the strongest of the species that survives, but the one most responsive to change",
                picture: "TextQuote.MindsetGrowth.CharlesDarwin",
                authorName: "- Charles Darwin"
            )
        ]
    }
}
