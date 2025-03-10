//
//  QuotesApp.swift
//  Quotes
//
//  Created by Tiffany Luu on 3/7/25.
//

import SwiftUI

@main
struct QuotesApp: App {
    let appGroup = "group.com.tiffanyluu.QuotesApp"
    
    init() {
        let sharedDefaults = UserDefaults(suiteName: appGroup)
        
        if sharedDefaults?.string(forKey: "sharedQuote") == nil {
            sharedDefaults?.set("Tap the app for a quote", forKey: "sharedQuote")
            sharedDefaults?.set("", forKey: "sharedAuthor")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            .onOpenURL {url in
                if url.scheme == "quotesapp" {
                    print("Widget tapped. Opening app...")
                }
            }
        }
    }
}
