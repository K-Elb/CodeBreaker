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
    
    let pegShape = Diamond()
    
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

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.closeSubpath()
        }
    }
}

#Preview {
    PegView(peg: "blue")
}
