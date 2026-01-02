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
    
    @State private var sortOption: GameList.SortOption = .name
    @State private var search: String = ""
    
    // MARK: - Body
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            Picker("Sort By", selection: $sortOption.animation(.default)) {
                ForEach(GameList.SortOption.allCases, id: \.self) { option in
                    Text(option.title)
                }
            }
            .padding(.horizontal)
            .pickerStyle(.segmented)
            
            GameList(sortBy: sortOption, nameContains: search, selection: $selection)
                .navigationTitle("Code Breaker")
                .searchable(text: $search)
            
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

#Preview(traits: .swiftData) {
    GameChooser()
}
