//
//  CodeView.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 28/12/2025.
//

import SwiftUI

struct CodeView: View {
    // MARK: Data in
    let code: Code
    
    // MARK: Data Shared with Me
    @Binding var selection: Int
    
    // MARK: - Body
    
    var body: some View {
        ForEach(code.pegs.indices , id: \.self) { index in
            PegView(peg: code.pegs[index])
                .padding(Selection.border)
                .background {
                    if selection == index, code.kind == .guess {
                        Selection.shape
                            .foregroundStyle(Selection.color)
                    }
                }
                .overlay {
                    Selection.shape
                        .foregroundStyle(code.isHidden ? Color.gray : .clear)
                }
                .onTapGesture {
                    if code.kind == .guess {
                        selection = index
                    }
                }
        }
    }
    
    struct Selection {
        static let border: CGFloat = 4
        static let cornerRadius: CGFloat = 16
        static let color: Color = Color.gray(0.8)
        static let shape = RoundedRectangle(cornerRadius: cornerRadius)
    }
}
