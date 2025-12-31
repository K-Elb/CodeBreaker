//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 31/12/2025.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data Owned by Me
    @State private var games: [CodeBreaker] = []
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(games) { game in
                    NavigationLink(value: game) {
                        GameSummary(game: game)
                    }
                    
//                    NavigationLink {
//                        CodeBreakerView(game: game)
//                    } label: {
//                        GameSummary(game: game)
//                    }
                    
//                    NavigationLink(value: game.masterCode.pegs) {
//                        Text("Cheat Code")
//                    }
                }
                .onDelete { offsets in
                    games.remove(atOffsets: offsets)
                }
                .onMove { offsets, destination in
                    games.move(fromOffsets: offsets, toOffset: destination)
                }
            }
            .navigationDestination(for: CodeBreaker.self) { game in
                CodeBreakerView(game: game)
            }
//            .navigationDestination(for: [Peg].self) { pegs in
//                PegChooser(choices: pegs)
//            }
            .navigationTitle("Code Breaker")
            
            .listStyle(.plain)
            .toolbar {
                EditButton()
            }
        }
        .onAppear {
            games.append(CodeBreaker(name: "Mastermind", pegChoices: [.blue, .red, .yellow, .green]))
            games.append(CodeBreaker(name: "Mastermind (Hard)", pegChoices: [.blue, .red, .yellow, .green, .cyan, .purple]))
            games.append(CodeBreaker(name: "Pastel", pegChoices: [.cyan, .mint, .pink, .purple]))
        }
    }
}

#Preview {
    GameChooser()
}
