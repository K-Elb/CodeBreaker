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
    
    // MARK: - Body
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible(minimum: 48)),GridItem(.flexible(minimum: 48)),GridItem(.flexible(minimum: 48)),GridItem(.flexible(minimum: 48))]) {
            ForEach(choices.indices, id: \.self) { i in
                    Button {
                        onChoose?(choices[i])
                    } label: {
                        PegView(peg: choices[i])
                    }
            }
        }
//        .aspectRatio(CGFloat(choices.count), contentMode: .fit)
    }
}

#Preview {
    PegChooser(choices: ["red", "blue", "yellow", "green", "orange", "pink"])
}
