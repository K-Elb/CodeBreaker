//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 31/12/2025.
//

import SwiftUI

struct GameSummary: View {
    let game: CodeBreaker
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.name)
                .font(.title2)
            
            PegChooser(choices: game.pegChoices)
                .frame(maxHeight: 48)
            
            Text("^[\(game.attempts.count) attempt](inflect: true)")
        }
    }
}
