//
//  GameSelector.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 24/03/2026.
//

import SwiftUI

struct GameSelector: View {
    @State private var type: String = "Colors"
    @State private var length: Int = 4
    
    var body: some View {
        NavigationStack {
            VStack {
                GameStat(type: type, length: length)
                
                CodeTypePicker(type: $type)
                
                CodeLengthPicker(length: $length)
                
                Spacer()
                
                NavigationLink{
                    switch type {
                    case "Colors":
                        CodeBreakerView(game: CodeBreaker(name: "Colors", pegChoices: ["red", "blue", "green", "cyan"], codeLength: length))
                    case "Words":
                        WordBreakerView(game: WordBreaker(codeLength: length))
                    default:
                        Text("Game not available")
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
    @Binding var length: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Code Length")
                .foregroundStyle(Color.secondary)
            
            HStack {
                ForEach(4..<7) { i in
                    Button(action: {length = i}) {
                        block(i)
                    }
                }
            }
        }
    }
    
    func block(_ int: Int) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundStyle(length == int ? .accent : .gray(0.95))
            .aspectRatio(2, contentMode: .fit)
            .overlay {
                Text("\(int)")
                    .font(.title2.bold())
                    .foregroundStyle(length == int ? .wb : .accent)
            }
    }
}

struct CodeTypePicker: View {
    @Binding var type: String
    @State private var types: [String] = ["Colors", "Words"]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Code Type")
                .foregroundStyle(Color.secondary)
            
            HStack {
                ForEach(types, id: \.self) { t in
                    Button(action: {type = t}) {
                        block(t)
                    }
                }
            }
        }
    }
    
    func block(_ int: String) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundStyle(type == int ? .accent : .gray(0.95))
            .aspectRatio(2, contentMode: .fit)
            .overlay {
                Text("\(int)")
                    .font(.title2.bold())
                    .foregroundStyle(type == int ? .wb : .accent)
            }
    }
}

struct GameStat: View {
    let type: String
    let length: Int
    
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
        .background(Color.gray(0.95), in: RoundedRectangle(cornerRadius: 16))
    }
    
    func blockTotal(value: String, title: String) -> some View {
        VStack(alignment: .leading) {
            Text(value)
                .font(.title2.bold())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            HStack {
                let pegs = Array(Peg.allCases.prefix(length))
                ForEach(pegs, id: \.self) { peg in
                    pegShape(peg)
                }
            }
            .frame(height: 56)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray(0.95), in: RoundedRectangle(cornerRadius: 16))
    }
    
    func pegShape(_ peg: Peg) -> some View {
        PegView(peg: peg.rawValue)
    }
}
