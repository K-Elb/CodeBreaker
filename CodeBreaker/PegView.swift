//
//  PegView.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 28/12/2025.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    let peg: Peg
    
    
    // MARK: - Body
    
    let pegShape = RoundedRectangle(cornerRadius: 12)
    
    var body: some View {
        pegShape
            .overlay {
                if peg == Code.missingPeg {
                    pegShape
                        .strokeBorder(Color.gray)
                }
            }
            .contentShape(pegShape)
            .aspectRatio(1, contentMode: .fit)
            .foregroundStyle(peg)
    }
}

#Preview {
    PegView(peg: .blue)
}
