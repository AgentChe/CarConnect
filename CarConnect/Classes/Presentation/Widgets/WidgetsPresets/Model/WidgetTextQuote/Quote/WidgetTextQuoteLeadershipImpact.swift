//
//  WidgetTextQuoteLeadershipImpact.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

struct WidgetTextQuoteLeadershipImpact: WidgetTextQuote {
    let text: String
    let picture: String
    let authorName: String
    
    static func templates() -> [WidgetTextQuoteLeadershipImpact] {
        [
            WidgetTextQuoteLeadershipImpact(
                text: "Innovation distinguishes between a leader and a follower",
                picture: "TextQuote.LeadershipImpact.SteveJobs",
                authorName: "- Steve Jobs"
            ),
            WidgetTextQuoteLeadershipImpact(
                text: "If you double the number of experiments you do per year you’re going to double your inventiveness",
                picture: "TextQuote.LeadershipImpact.JeffBezos",
                authorName: "- Jeff Bezos"
            ),
            WidgetTextQuoteLeadershipImpact(
                text: "Great companies are built on great products",
                picture: "TextQuote.LeadershipImpact.ElonMusk",
                authorName: "- Elon Musk"
            ),
            WidgetTextQuoteLeadershipImpact(
                text: "If you’re not embarrassed by the first version of your product, you’ve launched too late",
                picture: "TextQuote.LeadershipImpact.ReidHoffman",
                authorName: "- Reid Hoffman"
            ),
            WidgetTextQuoteLeadershipImpact(
                text: "The way to get started is to quit talking and begin doing",
                picture: "TextQuote.LeadershipImpact.WaltDisney",
                authorName: "- Walt Disney"
            ),
            WidgetTextQuoteLeadershipImpact(
                text: "Your most unhappy customers are your greatest source of learning",
                picture: "TextQuote.LeadershipImpact.BillGates",
                authorName: "- Bill Gates"
            ),
            WidgetTextQuoteLeadershipImpact(
                text: "The biggest risk is not taking any risk",
                picture: "TextQuote.LeadershipImpact.MarkZuckerberg",
                authorName: "- Mark Zuckerberg"
            ),
        ]
    }
}
