//
//  PegChoicesChooser.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 01/01/2026.
//

import SwiftUI

struct PegChoicesChooser: View {
    // MARK: Data Shared with Me
    @Binding var pegChoices: [Peg]
    
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
        if pegChoices.contains(where: { $0 == peg }) {
            pegChoices.removeAll(where: { $0 == peg })
        } else {
            pegChoices.append(peg)
        }
    }
    
    @ViewBuilder
    func button(_ peg: Peg) -> some View {
        if peg != .clear {
            PegView(peg: peg)
                .padding(4)
                .background {
                    Circle()
                        .foregroundStyle(pegChoices.contains(where: { $0 == peg }) ? Color.gray(0.8) : .clear)
                }
                .onTapGesture {
                    selectPeg(peg)
                }
        }
    }
}

#Preview {
    @Previewable @State var pegChoices: [Peg] = [.green,.orange]
    PegChoicesChooser(pegChoices: $pegChoices)
        .onChange(of: pegChoices) {
            print("pegChoices = \(pegChoices)")
        }
}
