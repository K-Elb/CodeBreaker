//
//  ElapsedTimeTrackerWords.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 09/01/2026.
//

import SwiftUI
import SwiftData

struct ElapsedTimeTrackerWords: ViewModifier {
    @Environment(\.modelContext) var modelContext
    @Environment(\.scenePhase) var scenePhase
    let game: WordBreaker
    
    var modelContentWillSavePublisher: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(
            for: ModelContext.willSave,
            object: modelContext
        )
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                game.startTimer()
            }
            .onDisappear {
                game.pauseTimer()
            }
            .onChange(of: game) { oldGame, newGame in
                oldGame.pauseTimer()
                newGame.startTimer()
            }
            .onChange(of: scenePhase) {
                switch scenePhase {
                case .active: game.startTimer()
                case .background: game.pauseTimer()
                default: break
                }
            }
            .onReceive(modelContentWillSavePublisher) { _ in
                game.updateElapsedTime()
                print("Updated elapsed time to \(game.elapsedTime)")
            }
    }
}

extension View {
    func trackElapsedTime(in game: WordBreaker) -> some View {
        self
            .modifier(ElapsedTimeTrackerWords(game: game))
    }
}
