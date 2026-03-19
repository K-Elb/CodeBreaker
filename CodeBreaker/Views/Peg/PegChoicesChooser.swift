//
//  PegChoicesChooser.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 01/01/2026.
//

import SwiftUI

struct PegChoicesChooser: View {
    // MARK: Data Shared with Me
    @Binding var pegChoices: [Peg.RawValue]
    
    var body: some View {
        List {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 64))]) {
                ForEach(Peg.allCases) { peg in
                    button(peg)
                }
            }
        }
    }
    
    func selectPeg(_ peg: Peg) {
        if pegChoices.contains(where: { $0 == peg.rawValue }) {
            pegChoices.removeAll(where: { $0 == peg.rawValue })
        } else {
            pegChoices.append(peg.rawValue)
        }
    }
    
    @ViewBuilder
    func button(_ peg: Peg) -> some View {
        if peg != .clear {
            PegView(peg: peg.rawValue)
                .opacity(pegChoices.contains(where: { $0 == peg.rawValue }) ? 1.0 : 0.3)
                .onTapGesture {
                    selectPeg(peg)
                }
        }
    }
}

#Preview {
    @Previewable @State var pegChoices: [Peg.RawValue] = ["red", "orange"]
    PegChoicesChooser(pegChoices: $pegChoices)
        .onChange(of: pegChoices) {
            print("pegChoices = \(pegChoices)")
        }
}
