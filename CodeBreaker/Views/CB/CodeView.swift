//
//  CodeView.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 28/12/2025.
//

import SwiftUI

struct CodeView<AncillaryView>: View where AncillaryView: View {
    // MARK: Data in
    let code: Code
    let matches: [Match]
    
    // MARK: Data Shared with Me
    @Binding var selection: Int
    
    @ViewBuilder let ancillaryView: () -> AncillaryView
    
    // MARK: Data Owned by Me
    @Namespace private var selectionNameSpace
    
    init(
        code: Code,
        matches: [Match] = [],
        selection: Binding<Int> = .constant(-1),
        @ViewBuilder ancillaryView: @escaping () -> AncillaryView = { EmptyView() }
    ) {
        self.code = code
        self.matches = matches
        self._selection = selection
        self.ancillaryView = ancillaryView
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            ForEach(code.pegs.indices , id: \.self) { index in
                ZStack(alignment: .topTrailing) {
                    PegView(peg: code.pegs[index])
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
                            }
                        }
                    
                    Group {
                        if selection == index, code.kind == .guess {
                            Selection.shape
                                .glassEffect(.clear, in: Selection.shape)
                                .padding(6)
                                .matchedGeometryEffect(id: "selection", in: selectionNameSpace)
                                .overlay {
                                    if let peg = Peg(rawValue: code.pegs[index]), peg != .clear {
                                        Image(systemName: peg.symbol)
                                            .flexibleSystemFont()
                                            .foregroundStyle(.wb)
                                    }
                                }
                        }
                    }
                    .animation(.selection, value: selection)
                    
                    if !matches.isEmpty {
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
            .padding(6)
    }
}

fileprivate struct Selection {
    static let border: CGFloat = 4
    static let color: Color = Color.gray(0.8)
    static let shape = RoundedRectangle(cornerRadius: 12)
}
