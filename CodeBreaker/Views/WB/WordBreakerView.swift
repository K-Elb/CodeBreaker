//
//  WordBreakerView.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 08/01/2026.
//

import SwiftUI

struct WordBreakerView: View {
    // MARK: Data In
    @Environment(\.words) var words
    
    // MARK: Data Shared with Me
    @State private var game = WordBreaker()
    
    // MARK: Data Owned by Me
    @State private var word: String = ""
    @State private var selection: Int = 0
    @State private var restarting = false
    @State private var hideMostRecentMarkers = false
    @State private var length: Int = 5
    
    @State private var focus: Bool = false
    @FocusState private var isFocused: Bool
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack {
                CodeViewWords(code: game.masterWord)
                    .background {
                        TextField("Type letter", text: $word)
                            .focused($isFocused)
                            .autocorrectionDisabled()
                            .keyboardType(.alphabet)
                            .onChange(of: word) {
                                if word != "" {
                                    changePegAtSelection(to: word)
                                }
                            }
                            .onSubmit {
                                guess()
                            }
                            .opacity(0)
                            .frame(width: 0, height: 0)
                    }
                
                ScrollView {
                    if !game.isOver {
                        CodeViewWords(code: game.guess, selection: $selection, isFocused: $focus)
                            .animation(nil, value: game.attempts.count)
                            .opacity(restarting ? 0 : 1)
                            .onChange(of: focus) {
                                isFocused = true
                            }
                    }
                    
                    ForEach(game.attempts, id: \.pegs) { attempt in
                        let showMarkers = !hideMostRecentMarkers || attempt.pegs != game.attempts.first?.pegs
                        if let matches = attempt.matches {
                            CodeViewWords(code: attempt, showMarkers: showMarkers, matches: matches)
                                .transition(.attempt(game.isOver))
                        }
                    }
                }
            }
            .navigationTitle(game.name)
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            .onChange(of: words.count) {
                randomWord()
            }
            .trackElapsedTime(in: game)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Restart", systemImage: "arrow.circlepath", action: restart)
                }
                
                ToolbarItem {
                    ElapsedTime(startTime: game.startTime, endTime: game.endTime, elapsedTime: game.elapsedTime)
                        .monospaced()
                        .lineLimit(1)
                }
            }
        }
    }
    
    func matchMarker(match: Match) -> some View {
        return Circle()
            .fill(match == .exact ? Color.primary : Color.clear)
            .strokeBorder(match != .nomatch ? Color.primary : Color.clear, lineWidth: 2)
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: 16)
            .padding(10)
    }
    
    func changePegAtSelection(to peg: Peg.RawValue) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.masterWord.pegs.count
        word = ""
    }
    
    func randomWord() {
        if let masterword = words.random(length: length) {
            game.masterWord = Code(kind: .master(isHidden: true), pegs: [])
            for char in masterword {
                game.masterWord.pegs.append("\(char)")
            }
            print(game.masterWord.pegs)
        }
    }
    
    func restart() {
        withAnimation(.restart) {
            randomWord()
            restarting = game.isOver
            game.restart()
            selection = 0
        } completion: {
            withAnimation(.restart) {
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
        word = ""
    }
}

#Preview {
    NavigationStack {
        WordBreakerView()
    }
}
