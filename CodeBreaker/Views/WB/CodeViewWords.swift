//
//  CodeView.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 28/12/2025.
//

import SwiftUI

struct CodeViewWords: View {
    // MARK: Data in
    let code: Code
    let showMarkers: Bool
    let matches: [Match]
    
    // MARK: Data Shared with Me
    @Binding var selection: Int
    @Binding var isFocused: Bool
        
    // MARK: Data Owned by Me
    @Namespace private var selectionNameSpace
    
    init(
        code: Code,
        showMarkers: Bool = false,
        matches: [Match] = [],
        selection: Binding<Int> = .constant(-1),
        isFocused: Binding<Bool> = .constant(false)
    ) {
        self.code = code
        self.showMarkers = showMarkers
        self.matches = matches
        self._selection = selection
        self._isFocused = isFocused
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            ForEach(code.pegs.indices , id: \.self) { index in
                ZStack(alignment: .topTrailing) {
                    PegView(peg: code.pegs[index])
                        .padding(Selection.border)
                        .background {
                            Group {
                                if selection == index, code.kind == .guess {
                                    Selection.shape
                                        .foregroundStyle(Selection.color)
                                        .matchedGeometryEffect(id: "selection", in: selectionNameSpace)
                                }
                            }
                            .animation(.selection, value: selection)
                        }
                        .overlay {
                            Selection.shape
                                .foregroundStyle(code.isHidden ? Color.gray : .clear)
                                .transaction { transaction in
                                    if code.isHidden {
                                        transaction.animation = nil
                                    }
                                }
                        }
                        .onTapGesture {
                            if code.kind == .guess {
                                selection = index
                                isFocused.toggle()
                            }
                        }
                    
                    if showMarkers, !matches.isEmpty {
                        matchMarker(match: matches[index])
                    }
                }
            }
        }
    }
    
    func matchMarker(match: Match) -> some View {
        return Circle()
            .fill(match == .exact ? Color.primary : Color.clear)
            .strokeBorder(match != .nomatch ? Color.primary : Color.clear, lineWidth: 2)
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: 16)
            .padding(8)
    }
}

fileprivate struct Selection {
    static let border: CGFloat = 0
    static let color: Color = Color.gray(0.8)
    static let shape = RoundedRectangle(cornerRadius: 16)
}

#Preview {
    CodeViewWords(code: Code(kind: .attempt([.exact, .exact, .exact]), pegs: ["s", "d", "d"]), showMarkers: true, matches: [.exact, .inexact, .nomatch])
}
