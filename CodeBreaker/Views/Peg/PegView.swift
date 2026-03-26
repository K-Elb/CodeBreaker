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
    let pegShape = RoundedRectangle(cornerRadius: 12)
    
    var body: some View {
        if let peg = Peg(rawValue: peg) {
            pegShape
                .overlay {
                    if peg != .clear {
                        Image(systemName: peg.symbol)
                            .flexibleSystemFont()
                            .foregroundStyle(peg.color)
                    }
                }
                .contentShape(pegShape)
                .aspectRatio(1, contentMode: .fit)
                .foregroundStyle(peg.color.secondary)
        } else {
            pegShape
                .foregroundStyle(.gray.opacity(0.2))
                .overlay {
                    Text(peg)
                        .font(.title)
                }
                .contentShape(pegShape)
                .aspectRatio(1, contentMode: .fit)
                
        }
    }
}

#Preview {
    PegView(peg: "red")
}
