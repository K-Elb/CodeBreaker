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
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack {
                CodeView(code: game.masterCode) {
                    if game.isOver {
                        resetButton
                    }
                }
                
                ScrollView {
                    if !game.isOver {
                        CodeView(code: game.guess, selection: $selection) {
                            guessButton
                        }
                    }
                    
                    ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                        CodeView(code: game.attempts[index]) {
                                if let matches = game.attempts[index].matches {
                                    MatchMarkers(matches: matches)
                                }
                            }
                        .transition(.asymmetric(insertion: .scale(scale: 4), removal: .identity))
                    }
                }
                
                PegChooser(choices: game.pegChoices) { peg in
                    game.setGuessPeg(peg, at: selection)
                    selection = (selection + 1) % game.masterCode.pegs.count
                }
            }
            .navigationTitle("CodeBreaker")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
        }
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
                selection = 0
            }
        }
        .font(.system(size: GuessButton.maximumFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor)
    }
    
    var resetButton: some View {
        Button("Reset") {
            withAnimation {
                game.randomiseMasterCode()
            }
        }
        .font(.system(size: GuessButton.maximumFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor)
    }
    
    struct GuessButton {
        static let minimumFontSize: CGFloat = 8
        static let maximumFontSize: CGFloat = 80
        static let scaleFactor: CGFloat = minimumFontSize / maximumFontSize
    }
}

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}

#Preview {
    CodeBreakerView()
}
