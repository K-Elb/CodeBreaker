//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 31/12/2025.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data Owned by Me
    @State private var selection: CodeBreaker? = nil
    
    // MARK: - Body
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            GameList(selection: $selection)
                .navigationTitle("Code Breaker")
        } detail: {
            if let selection {
                CodeBreakerView(game: selection)
                    .navigationTitle(selection.name)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Choose a game!")
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview {
    GameChooser()
}
