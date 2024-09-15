//
//  SettingsView.swift
//  CryptoTracker
//
//  Created by Prajwal V on 11/09/24.
//

import SwiftUI

struct SettingsView: View {
    let defaulURL = URL(string:"https://www.google.com")!
    let youtubeURL = URL(string:"https://www.youtube.com")!
    let youtubeURL2 = URL(string:"https://www.youtube.com")!
    let coingekoURl = URL(string:"https://api.coingecko.com")!
    let personalURL = URL(string:"https://api.coingecko.com")!
    
    var body: some View {
        NavigationView{
            List{
                SwiftfulThinkingSection
                coinGeckoSection
                developerSection
                applicationSection
            }
            .font(.headline)
            .accentColor(.blue)
            .navigationTitle("Settings")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    XMarkButton()
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}

extension SettingsView{
    
    private var SwiftfulThinkingSection: some View{
        Section(header: Text("Swiftful Thinking")){
            VStack(alignment:.leading){
                Image("logo")
                    .resizable()
                    .frame(width: 100,height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made by following a @Swiftful course. It uses MVVM Architecture, Combine, and CoreData!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("YouTube", destination: youtubeURL)
            Link("YouTube2 ", destination: youtubeURL2)
        }
    }
    
    private var coinGeckoSection: some View{
        Section(header: Text("CoinGecko")){
            VStack(alignment:.leading){
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100,height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit CoinGecko", destination: coingekoURl)
        }
    }
    
    private var developerSection: some View{
        Section(header: Text("Developer")){
            VStack(alignment:.leading){
                Image("logo")
                    .resizable()
                    .frame(width: 100,height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was developed by Prajwal V")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit Website", destination: personalURL)
        }
    }
    
    private var applicationSection: some View{
        Section(header: Text("Application")){
            Link("Terms of Service", destination: personalURL)
            Link("Privacy Policy", destination: personalURL)
            Link("Company Website", destination: personalURL)
            Link("Learn more", destination: personalURL)
        }
    }
}
