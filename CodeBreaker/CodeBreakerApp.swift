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
                GameChooser()
                    .modelContainer(for: CodeBreaker.self)
                    .environment(\.sceneFrame, geometry.frame(in: .global))
            }
        }
    }
}

extension EnvironmentValues {
    @Entry var sceneFrame: CGRect = UIScreen.main.bounds
}
