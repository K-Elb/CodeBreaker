//
//  GameSelector.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 24/03/2026.
//

import SwiftUI

struct GameSelector: View {
    @State private var game: CodeBreaker = CodeBreaker(name: "Colors", pegChoices: ["red", "blue", "green", "cyan"], codeLength: 4)
    
    var body: some View {
        NavigationStack {
            VStack {
                GameStat(game: game)
                
                CodeTypePicker(game: game)
                
                CodeLengthPicker(game: $game)
                
                Spacer()
                
                NavigationLink{
                    switch game.name {
                    case "Colors":
                        CodeBreakerView(game: game)
                    case "Words":
                        WordBreakerView()
                    default:
                        Text("")
                    }
                } label: {
                    Label("Start", systemImage: "play.fill")
                        .font(.title2.bold())
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.wb)
                        .background(.accent, in: .capsule)
                }
            }
            .padding(.horizontal)
            .navigationTitle("Code Breaker")
        }
    }
}

#Preview(traits: .swiftData) {
    GameSelector()
}

struct CodeLengthPicker: View {
    @Binding var game: CodeBreaker
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Code Length")
                .foregroundStyle(Color.secondary)
            
            HStack {
                ForEach(4..<7) { i in
                    Button(action: {button(i)}) {
                        block(i)
                    }
                }
            }
        }
    }
    
    func block(_ int: Int) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundStyle(game.codeLength == int ? .accent : .clear)
            .aspectRatio(2, contentMode: .fit)
            .overlay {
                Text("\(int)")
                    .font(.title2.bold())
                    .foregroundStyle(game.codeLength == int ? .wb : .accent)
            }
    }
    
    func button(_ i: Int) {
        let somepegs = Array(Peg.allCases.prefix(i))
        let pegs = somepegs.map{ $0.rawValue }
        game = CodeBreaker(name:game.name ,pegChoices: pegs, codeLength: i)
    }
}

struct CodeTypePicker: View {
    var game: CodeBreaker
    @State private var types: [String] = ["Colors", "Words"]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Code Type")
                .foregroundStyle(Color.secondary)
            
            HStack {
                ForEach(types, id: \.self) { type in
                    Button(action: {game.name = type}) {
                        block(type)
                    }
                }
            }
        }
    }
    
    func block(_ int: String) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundStyle(game.name == int ? .accent : .clear)
            .aspectRatio(2, contentMode: .fit)
            .overlay {
                Text("\(int)")
                    .font(.title2.bold())
                    .foregroundStyle(game.name == int ? .wb : .accent)
            }
    }
}

struct GameStat: View {
    var game: CodeBreaker
    var somePegs: [Peg] {
        Array(Peg.allCases.prefix(game.codeLength))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
//            Text("Stats")
//                .foregroundStyle(Color.secondary)
            
            blockTotal(value: "321", title: "Career Total")

            HStack {
                block(symbol: "trophy.fill", value: "2,452", title: "High Score")
                block(symbol: "clock.fill", value: "1:56", title: "Best Time")
            }
        }
    }
    
    func block(symbol: String, value: String, title: String) -> some View {
        VStack(alignment: .leading) {
            Image(systemName: symbol)
                .font(.title2.bold())
            Text(value)
                .font(.title2.bold())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.horizontal, .bottom])
        .padding(.top, 32)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    func blockTotal(value: String, title: String) -> some View {
        VStack(alignment: .leading) {
            Text(value)
                .font(.title2.bold())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            HStack {
                ForEach(game.pegChoices, id: \.self) { peg in
                    pegs(peg)
                }
            }
            .frame(height: 56)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    func pegs(_ peg: String) -> some View {
        PegView(peg: peg)
    }
}
