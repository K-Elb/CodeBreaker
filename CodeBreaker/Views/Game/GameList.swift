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
        let completedOnly = sortBy == .completed
        let predicate = #Predicate<CodeBreaker> { game in
            (!completedOnly || game.isOver) &&
            (search.isEmpty || game.name.contains(loweraseSearch) || game.name.contains(uppercaseSearch))
        }
        switch sortBy {
        case .name: _games = Query(filter: predicate, sort: \CodeBreaker.name, order: .forward)
        case .recent, .completed: _games = Query(filter: predicate, sort: \CodeBreaker.lastAttemptDate, order: .reverse)
        }
    }
    
    enum SortOption: CaseIterable {
        case name, recent, completed
        
        var title: String {
            switch self {
            case .name: "Sort by Name"
            case .recent: "Recent"
            case .completed: "Completed"
            }
        }
    }
    
    var summarySize: GameSummary.Size {
        staticSummarySize * dynamicSummarySizeMagnification
    }
    @State private var staticSummarySize: GameSummary.Size = .large
    @State private var dynamicSummarySizeMagnification: CGFloat = 1.0
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameSummary(game: game, size: summarySize)
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
        .gesture(summarySizeMagnifier)
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
        .task { await addSampleGames() }
    }
    
    var summarySizeMagnifier: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                dynamicSummarySizeMagnification = value.magnification
            }
            .onEnded { value in
                staticSummarySize = staticSummarySize * value.magnification
                dynamicSummarySizeMagnification = 1.0
            }
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
    
    func addSampleGames() async {
        let fetchDescriptor = FetchDescriptor<CodeBreaker>()
        if let results = try? modelContext.fetchCount(fetchDescriptor), results == 0 {
//                modelContext.insert(CodeBreaker(name: "RGB", pegChoices: ["red", "green", "blue"]))
//                modelContext.insert(CodeBreaker(name: "Mastermind", pegChoices: ["blue", "red", "yellow", "green", "cyan", "purple"]))
//                modelContext.insert(CodeBreaker(name: "Pastel", pegChoices: ["cyan", "mint", "pink", "purple"]))
            for url in sampleGamesURLS {
                do {
                    let (json, _) = try await URLSession.shared.data(from: url)
                    let game = try JSONDecoder().decode(CodeBreaker.self, from: json)
                    modelContext.insert(game)
                    print("Loaded sample games from \(url)")
                } catch {
                    print("Couldn't load a sample game: \(error.localizedDescription)")
                }
            }
        }
    }
    
    var sampleGamesURLS: [URL] {
        Bundle.main.paths(forResourcesOfType: "json", inDirectory: nil)
            .map { URL(filePath: $0) }
    }
}

extension GameSummary.Size {
    static func *(lhs: Self, rhs: CGFloat) -> Self {
        switch rhs {
        case 2.0...: lhs.larger.larger
        case 1.5...: lhs.larger
        case ...0.35: lhs.smaller.smaller
        case ...0.5: lhs.smaller
        default: lhs
        }
    }
}

#Preview(traits: .swiftData) {
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}
