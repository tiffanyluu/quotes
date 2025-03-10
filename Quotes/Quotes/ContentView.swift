import SwiftUI
import WidgetKit

struct ContentView: View {
    
    @State private var randomQuote: String = "Tap for a quote"
    @State private var author: String = ""
    
    let appGroup = "group.com.tiffanyluu.QuotesApp"
    
    var body: some View {
        ZStack {
            Color(Color(red: 214/255, green: 207/255, blue: 159/255))
                .ignoresSafeArea()
                
            VStack(alignment: .center) {
                Spacer()
                Text(randomQuote)
                    .font(.system(size: 24, weight: .medium, design: .serif))
                    .multilineTextAlignment(.center)
                    .padding()
                Text(author.isEmpty || randomQuote == "Tap for a quote" ? "" : "- \(author)")
                    .font(.system(size: 15, weight: .light, design: .serif))
                    .foregroundColor(Color(red: 100/255, green: 80/255, blue: 60/255))
                Spacer()
                
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        ShareLink(item: randomQuote) {
                            Text("Share Quote")
                                .font(.custom("Georgia", size: 18))
                                .padding(12)
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 194/255, green: 187/255, blue: 139/255))
                                .foregroundColor(.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(red: 120/255, green: 90/255, blue: 60/255), lineWidth: 2) // Brown border
                                )
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            UIPasteboard.general.string = randomQuote
                        }) {
                            Text("Copy Quote")
                                .font(.custom("Georgia", size: 18))
                                .padding(12)
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 194/255, green: 187/255, blue: 139/255))
                                .foregroundColor(.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(red: 120/255, green: 90/255, blue: 60/255), lineWidth: 2) // Brown border
                                )
                                .cornerRadius(10)
                        }
                    }
                    
                    Button(action: {
                        Task {
                            do {
                                let quote = try await fetchRandomQuote()
                                randomQuote = quote.text
                                author = quote.author
                                
                                if let sharedDefaults = UserDefaults(suiteName: appGroup) {
                                    sharedDefaults.set(quote.text, forKey: "sharedQuote")
                                    sharedDefaults.set(quote.author, forKey: "sharedAuthor")
                                    sharedDefaults.synchronize()
                                }
                                WidgetCenter.shared.reloadAllTimelines()
                                
                            } catch {
                                print("Error fetching quote: \(error)")
                                randomQuote = "Failed to fetch quote"
                                author = ""
                            }
                        }
                    }) {
                        Text("New Quote")
                            .font(.custom("Georgia", size: 18))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 194/255, green: 187/255, blue: 139/255))
                            .foregroundColor(.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(red: 120/255, green: 90/255, blue: 60/255), lineWidth: 2) // Brown border
                            )
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding()
            }
            .padding()
        }
    }
}
//
//#Preview {
//    ContentView()
//}
