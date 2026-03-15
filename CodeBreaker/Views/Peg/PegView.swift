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
                            .foregroundStyle(.wb)
                    }
                }
                .contentShape(pegShape)
                .aspectRatio(1, contentMode: .fit)
                .foregroundStyle(peg.color)
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
    PegView(peg: "red")
}
