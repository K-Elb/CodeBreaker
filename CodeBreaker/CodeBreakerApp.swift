//
//  CodeBreakerApp.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 26/12/2025.
//

import SwiftUI
import SwiftData

@main
struct CodeBreakerApp: App {
    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
                TabView {
                    Tab {
                        GameChooser()
                            .modelContainer(for: CodeBreaker.self)
                            .environment(\.sceneFrame, geometry.frame(in: .global))
                    } label: {
                        Label("Game", systemImage: "flame")
                    }
                    Tab {
                        NavigationStack {
                            WordBreakerView()
                        }
                    } label: {
                        Label("Word", systemImage: "sparkles")
                    }
                }
            }
        }
    }
}

extension EnvironmentValues {
    @Entry var sceneFrame: CGRect = UIScreen.main.bounds
}
