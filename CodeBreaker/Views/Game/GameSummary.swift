//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 31/12/2025.
//

import SwiftUI

struct GameSummary: View {
    let game: CodeBreaker
    var size: Size = .regular
    
    enum Size {
        case compact, regular, large
        
        var larger: Size {
            switch self {
            case .compact: .regular
            default: .large
            }
        }
        
        var smaller: Size {
            switch self {
            case .large: .regular
            default: .compact
            }
        }
    }
    
    var body: some View {
        let layout = size == .compact ? AnyLayout(HStackLayout()) :  AnyLayout(VStackLayout(alignment: .leading))
        layout {
            Text(game.name)
                .font(.title2)
            
            PegChooser(choices: game.pegChoices)
                .frame(maxHeight: size == .compact ? 40 : 56)
            
            if size == .large {
                Text("^[\(game.attempts.count) attempt](inflect: true)")
            }
        }
    }
}

#Preview(traits: .swiftData) {
    List {
        GameSummary(game: CodeBreaker(name: "Test Game", pegChoices: ["red", "blue", "green", "yellow"]))
    }
}
