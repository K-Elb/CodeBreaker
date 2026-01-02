//
//  PegView.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 28/12/2025.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    let peg: Peg.RawValue
    
    
    // MARK: - Body
    
    let pegShape = Circle()
    
    var body: some View {
        if let peg = Peg(rawValue: peg) {
            pegShape
                .overlay {
                    Image(systemName: peg.symbol)
                        .font(.title2)
                        .foregroundStyle(peg.color.gradient)
                }
                .contentShape(pegShape)
                .aspectRatio(1, contentMode: .fit)
                .foregroundStyle(peg.color.opacity(0.2))
        }
    }
}

#Preview {
    PegView(peg: "blue")
}
