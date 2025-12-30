//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 26/12/2025.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data Owned by Me
    @State private var game = CodeBreaker(pegChoices: [.red, .green, .blue, .cyan])
    @State private var selection: Int = 0
    @State private var restarting = false
    @State private var hideMostRecentMarkers = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack {
                CodeView(code: game.masterCode)
                
                ScrollView {
                    if !game.isOver || restarting {
                        CodeView(code: game.guess, selection: $selection) {
                            Button("Guess", action: guess)
                                .flexibleSystemFont()
                        }
                        .animation(nil, value: game.attempts.count)
                        .opacity(restarting ? 0 : 1)
                    }
                    
                    ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                        CodeView(code: game.attempts[index]) {
                            let showMarkers = !hideMostRecentMarkers || index != game.attempts.count - 1
                            if showMarkers, let matches = game.attempts[index].matches {
                                MatchMarkers(matches: matches)
                            }
                        }
                        .transition(AnyTransition.attempt(game.isOver))
                    }
                }
                
                if !game.isOver {
                    PegChooser(choices: game.pegChoices, onChoose: changePegAtSelection)
                        .transition(.pegChooser)
                }
            }
            .navigationTitle("CodeBreaker")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            .toolbar {
                ToolbarItem {
                    Button("Restart", systemImage: "arrow.circlepath", action: restart)
                }
            }
        }
    }
    
    func changePegAtSelection(to peg: Peg) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.masterCode.pegs.count
    }
    
    func restart() {
        withAnimation(.restart) {
            restarting = true
        } completion: {
            withAnimation(.restart) {
                game.restart()
                selection = 0
                restarting = false
            }
        }
    }
    
    func guess() {
        withAnimation(.guess) {
            game.attemptGuess()
            selection = 0
            hideMostRecentMarkers = true
        } completion: {
            withAnimation(.guess) {
                hideMostRecentMarkers = false
            }
        }
    }
}

#Preview {
    CodeBreakerView()
}
