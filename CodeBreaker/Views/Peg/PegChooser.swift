//
//  PegChooser.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 28/12/2025.
//

import SwiftUI

struct PegChooser: View {
    // MARK: Data In
    let choices: [Peg.RawValue]
    
    // MARK: Data Out
    var onChoose: ((Peg.RawValue) -> Void)?
    var columns: [GridItem] {
        if choices.count <= 6 {
            return Array(repeating: GridItem(.flexible(minimum: 48, maximum: 96)), count: choices.count)
        } else {
            return Array(repeating: GridItem(.flexible(minimum: 48, maximum: 96)), count: 6)
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(choices.indices, id: \.self) { i in
                Button {
                    onChoose?(choices[i])
                } label: {
                    PegView(peg: choices[i])
                }
            }
        }
    }
}

#Preview {
    PegChooser(choices: ["red", "blue", "yellow", "green", "orange", "pink"])
}
