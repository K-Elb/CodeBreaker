//
//  GameList.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 01/01/2026.
//

import SwiftUI
import SwiftData

struct GameList: View {
    // MARK: Data In
    @Environment(\.modelContext) var modelContext
    
    // MARK: Data Shared with Me
    @Binding var selection: CodeBreaker?
    @Query private var games: [CodeBreaker]
    
    // MARK: Data Owned by Me
    @State private var gameToEdit: CodeBreaker?
    
    init(sortBy: SortOption = .name, nameContains search: String = "", selection: Binding<CodeBreaker?>) {
        _selection = selection
        let loweraseSearch = search.lowercased()
        let uppercaseSearch = search.uppercased()
        let predicate = #Predicate<CodeBreaker> { game in
            search.isEmpty || game.name.contains(loweraseSearch) || game.name.contains(uppercaseSearch)
        }
        switch sortBy {
        case .name: _games = Query(filter: predicate, sort: \CodeBreaker.name, order: .forward)
        case .recent: _games = Query(filter: predicate, sort: \CodeBreaker.lastAttemptDate, order: .reverse)
        }
    }
    
    enum SortOption: CaseIterable {
        case name, recent
        
        var title: String {
            switch self {
            case .name: "Sort by Name"
            case .recent: "Recent"
            }
        }
    }
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameSummary(game: game)
                }
                .contextMenu {
//                    editButton(for: game) // editing a game
                    deleteButton(for: game)
                }
//                .swipeActions(edge: .leading) {
//                    editButton(for: game).tint(.accentColor) // editing a game
//                }
            }
            .onDelete { offsets in
                for offset in offsets {
                    modelContext.delete(games[offset])
                }
            }
//            .onMove { offsets, destination in
//                games.move(fromOffsets: offsets, toOffset: destination)
//            }
        }
        .onChange(of: games) {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
        .listStyle(.plain)
        .toolbar {
            addButton
            EditButton() // editing the List of games
        }
        .onAppear { addSampleGames() }
    }
    
//    func editButton(for game: CodeBreaker) -> some View {
//        Button("Edit", systemImage: "pencil") {
//            gameToEdit = game
//        }
//    }
    
    var addButton: some View {
        Button("Add Game", systemImage: "plus") {
            gameToEdit = CodeBreaker(name: "Untitled", pegChoices: ["red", "blue"])
        }
        .sheet(isPresented: showGameEditor) {
            gameEditor
        }
    }
    
    @ViewBuilder
    var gameEditor: some View {
        if let gameToEdit {
            let copyOfGameToEdit = CodeBreaker(name: gameToEdit.name, pegChoices: gameToEdit.pegChoices)
            GameEditor(game: copyOfGameToEdit) {
                if games.contains(gameToEdit) {
                    modelContext.delete(gameToEdit)
                }
                modelContext.insert(copyOfGameToEdit)
            }
        }
    }
    
    var showGameEditor: Binding<Bool> {
        Binding<Bool>(
            get: { gameToEdit != nil },
            set: { newValue in
                if !newValue {
                    gameToEdit = nil
                }
            }
        )
    }
    
    func deleteButton(for game: CodeBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                modelContext.delete(game)

            }
        }
    }
    
    func addSampleGames() {
        if games.isEmpty {
            modelContext.insert(CodeBreaker(name: "RGB", pegChoices: ["red", "green", "blue"]))
            modelContext.insert(CodeBreaker(name: "Mastermind", pegChoices: ["blue", "red", "yellow", "green", "cyan", "purple"]))
            modelContext.insert(CodeBreaker(name: "Pastel", pegChoices: ["cyan", "mint", "pink", "purple"]))
        }
    }
}

#Preview(traits: .swiftData) {
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}
