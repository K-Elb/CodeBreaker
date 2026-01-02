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
            GameChooser()
                .modelContainer(for: CodeBreaker.self)
        }
    }
}
