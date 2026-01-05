//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 26/12/2025.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data In
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.sceneFrame) var sceneFrame
    
    // MARK: Data Shared with Me
    let game: CodeBreaker
    
    // MARK: Data Owned by Me
    @State private var selection: Int = 0
    @State private var restarting = false
    @State private var hideMostRecentMarkers = false
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            CodeView(code: game.masterCode)
            
            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection) {
                        Button("Guess", action: guess)
                            .flexibleSystemFont()
                    }
                    .animation(nil, value: game.attempts.count)
                    .opacity(restarting ? 0 : 1)
                }
                
                ForEach(game.attempts, id: \.pegs) { attempt in
                    CodeView(code: attempt) {
                        let showMarkers = !hideMostRecentMarkers || attempt.pegs != game.attempts.first?.pegs
                        if showMarkers, let matches = attempt.matches {
                            MatchMarkers(matches: matches)
                        }
                    }
                    .transition(.attempt(game.isOver))
                }
            }
            
            GeometryReader { geometry in
                if !game.isOver {
                    let offset = sceneFrame.maxY - geometry.frame(in: .global).minY
                    PegChooser(choices: game.pegChoices, onChoose: changePegAtSelection)
                        .transition(.offset(y: offset))
                }
            }
            .aspectRatio(CGFloat(game.pegChoices.count), contentMode: .fit)
            .frame(maxHeight: 80)
        }
        .navigationTitle(game.name)
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal)
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
        .highPriorityGesture(pegChoosingDial)
    }
    
    var pegChoosingDial: some Gesture {
        RotationGesture()
            .onChanged { value in
                let pegChoicesIndex = Int(abs(value.degrees)/90) %  game.pegChoices.count
                game.guess.pegs[selection] = game.pegChoices[pegChoicesIndex]
            }
        
    }
    
    func changePegAtSelection(to peg: Peg.RawValue) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.masterCode.pegs.count
    }
    
    func restart() {
        withAnimation(.restart) {
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
    }
}

#Preview(traits: .swiftData) {
    @Previewable @State var game = CodeBreaker(name: "", pegChoices: ["blue", "red", "yellow", "green"])
    CodeBreakerView(game: game)
}
