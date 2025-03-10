//
//  QuotesWidget.swift
//  QuotesWidget
//
//  Created by Tiffany Luu on 3/9/25.
//

import WidgetKit
import SwiftUI

struct QuoteEntry: TimelineEntry {
    let date: Date
    let quote: String
    let author: String
    
    static let placeholder = QuoteEntry(date: Date(), quote: "Tap the app for a quote", author: "")
}

struct QuotesProvider: TimelineProvider {
    let appGroup = "group.com.tiffanyluu.QuotesApp"
    
    func placeholder(in context: Context) -> QuoteEntry {
        return QuoteEntry.placeholder
    }
    
    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> Void) {
        completion(QuoteEntry.placeholder)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteEntry>) -> Void) {
        let entry = loadQuote()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 1, to: Date()) ?? Date()

        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate)) // ✅ Forces refresh
        completion(timeline)
    }
    
    private func loadQuote() -> QuoteEntry {
        let sharedDefaults = UserDefaults(suiteName: appGroup)
            
        let quote = sharedDefaults?.string(forKey: "sharedQuote") ?? "Tap the app for a quote"
        let author = sharedDefaults?.string(forKey: "sharedAuthor") ?? ""
        
        return QuoteEntry(date: Date(), quote: quote, author: author)
    }
}

struct QuotesWidgetEntryView: View {
    var entry: QuoteEntry
    var body: some View {
        Link(destination: URL(string: "quotesapp://open")!) {
            VStack {
                Text(entry.quote)
                    .font(.system(size: 16, weight: .medium, design: .serif))
                    .multilineTextAlignment(.center)
                    .padding()
                if !entry.author.isEmpty {
                    Text("- \(entry.author)")
                        .font(.system(size: 12, weight: .light, design: .serif))
                        .foregroundColor(.brown)
                }
            }
        }
        .padding()
        .containerBackground(for: .widget) {
                    Color(red: 214/255, green: 207/255, blue: 159/255)
        }
    }
}

struct QuotesWidget: Widget {
    let kind: String = "QuotesWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuotesProvider()) {entry in
            QuotesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Quotes")
        .description("Displays a random inspirational quote.")
        .supportedFamilies([.systemMedium])
    }
}
