//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var id: Int
    var team: String
    var opponent: String
    var isHomeGame: Bool
    var date: String
    var score: Score
    
    struct Score: Codable {
        var opponent: Int
        var unc: Int
    }
}

struct ContentView: View {
    @State private var results = [Result]()
    
    var body: some View {
        NavigationStack {
            List(results, id: \.id) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(item.team) vs. \(item.opponent)")
                        Text(item.date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(item.score.unc) - \(item.score.opponent)")
                        Text(item.isHomeGame ? "Home" : "Away")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("UNC Basketball")
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([Result].self, from: data) {
                results = decodedResponse
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
