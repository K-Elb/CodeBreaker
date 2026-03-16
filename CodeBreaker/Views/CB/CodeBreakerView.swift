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
//    @State private var hideMostRecentMarkers = false
    @State private var guessButton: Bool = false
    @State private var warningButton: Bool = false
    @State private var pegButton: Bool = false
    @State private var doneButton: Bool = false
    @State private var shakeOffset: CGFloat = 0

    
    // MARK: - Body
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                ScrollView(showsIndicators: false) {
                    CodeView(code: game.masterCode)
                        .sensoryFeedback(.success, trigger: doneButton)
                    
                    if !game.isOver {
                        CodeView(code: game.guess, selection: $selection)
                            .animation(nil, value: game.attempts.count)
                            .opacity(restarting ? 0 : 1)
                    }
                    
                    ForEach(game.attempts, id: \.pegs) { attempt in
                        if let matches = attempt.matches {
                            CodeView(code: attempt, matches: matches)
                                .transition(.attempt(game.isOver))
                        }
                    }
                }
                
                if !game.isOver {
                    VStack {
                        PegChooser(choices: game.pegChoices, onChoose: changePegAtSelection)
                            .aspectRatio(CGFloat(game.pegChoices.count), contentMode: .fit)
                            .sensoryFeedback(.impact(flexibility: .soft), trigger: pegButton)
//                            .frame(maxHeight: 80)
                            
                        
                        HStack {
                            Button(action: clear) {
                                Label("Clear", systemImage: "eraser.fill")
                                    .frame(maxWidth: .infinity)
                                    .font(.title2.bold())
                            }
                            .buttonStyle(.glass)
                            
                            Button(action: guess) {
                                Label("Guess", systemImage: "questionmark")
                                    .frame(maxWidth: .infinity)
                                    .font(.title2.bold())
                            }
                            .buttonStyle(.borderedProminent)
                            .sensoryFeedback(.impact, trigger: guessButton)
                            .sensoryFeedback(.warning, trigger: warningButton)
                        }
                        .padding(.horizontal)
                    }
                    .padding(8)
                    .padding(.bottom, 8)
                    .glassEffect(.regular, in: .rect)
                    .transition(.push(from: .top))
                    .opacity(restarting ? 0 : 1)
                    .offset(x: shakeOffset)
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .navigationTitle(game.name)
        .navigationBarTitleDisplayMode(.inline)
        .trackElapsedTime(in: game)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Restart", systemImage: "arrow.circlepath", action: restart)
            }
            
            ToolbarItem {
                Button("Save", systemImage: "square.and.arrow.down") {
                    if let json = try? JSONEncoder().encode(game) {
                        let url = URL.documentsDirectory.appendingPathComponent(game.name).appendingPathExtension("json")
                        try? json.write(to: url)
                    }
                }
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
        pegButton.toggle()
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
            if game.validAttempt() {
                game.attemptGuess()
                selection = 0
                if game.isOver {
                    doneButton.toggle()
                } else {
                    guessButton.toggle()
                }
            } else {
                shake()
                warningButton.toggle()
            }
//            hideMostRecentMarkers = true
        } completion: {
            withAnimation(.guess) {
//                hideMostRecentMarkers = false
            }
        }
    }
    
    func clear() {
        withAnimation {
            game.guess.reset(length: game.codeLength)
            selection = 0
        }
    }
    
    func shake() {
        withAnimation(.easeInOut(duration: 0.1)) {
            shakeOffset = 4
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.1)) {
                shakeOffset = -4
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.1)) {
                shakeOffset = 0
            }
        }
    }
}

#Preview(traits: .swiftData) {
    @Previewable @State var game = CodeBreaker(name: "", pegChoices: ["blue", "red", "yellow", "green"])
    
    NavigationView {
        CodeBreakerView(game: game)
    }
}
