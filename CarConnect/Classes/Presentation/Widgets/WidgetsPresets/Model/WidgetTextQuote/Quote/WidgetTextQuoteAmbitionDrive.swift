//
//  WidgetTextQuoteAmbitionDrive.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

struct WidgetTextQuoteAmbitionDrive: WidgetTextQuote {
    let text: String
    let picture: String
    let authorName: String
    let authorSocialRole: String
    
    static func templates() -> [WidgetTextQuoteAmbitionDrive] {
        [
            WidgetTextQuoteAmbitionDrive(
                text: "Success usually comes to those who are too busy to be looking for it",
                picture: "TextQuote.AmbitionDrive.HenryDavidThoreau",
                authorName: "Henry David Thoreau",
                authorSocialRole: "Writer"
            ),
            WidgetTextQuoteAmbitionDrive(
                text: "Whether you think you can or you think you can’t, you’re right",
                picture: "TextQuote.AmbitionDrive.HentyFord",
                authorName: "Henry Ford",
                authorSocialRole: "Industrialist"
            ),
            WidgetTextQuoteAmbitionDrive(
                text: "Action is the foundational key to all success",
                picture: "TextQuote.AmbitionDrive.PabloPicasso",
                authorName: "Pablo Picasso",
                authorSocialRole: "Artist"
            ),
            WidgetTextQuoteAmbitionDrive(
                text: "It always seems impossible until it’s done",
                picture: "TextQuote.AmbitionDrive.NelsonMandela",
                authorName: "Nelson Mandela",
                authorSocialRole: "President"
            ),
            WidgetTextQuoteAmbitionDrive(
                text: "The only way to do great work is to love what you do",
                picture: "TextQuote.AmbitionDrive.SteveJobs",
                authorName: "Steve Jobs",
                authorSocialRole: "Entrepreneur"
            ),
            WidgetTextQuoteAmbitionDrive(
                text: "If you’re going through hell, keep going",
                picture: "TextQuote.AmbitionDrive.WinstonChurchill",
                authorName: "Winston Churchill",
                authorSocialRole: "Prime Minister"
            ),
            WidgetTextQuoteAmbitionDrive(
                text: "I am not a product of my circumstances. I am a product of my decisions",
                picture: "TextQuote.AmbitionDrive.StephenRCovey",
                authorName: "Stephen R. Covey",
                authorSocialRole: "Author"
            ),
        ]
    }
}
