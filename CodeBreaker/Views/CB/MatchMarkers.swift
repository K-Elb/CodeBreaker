//
//  MatchMarkers.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 26/12/2025.
//

import SwiftUI

struct MatchMarkers: View {
    // MARK: Data In
    let matches: [Match]
    
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            VStack {
                matchMarker(peg: 0)
                matchMarker(peg: 1)
            }
            VStack {
                matchMarker(peg: 2)
                matchMarker(peg: 3)
            }
        }
        .padding(4)
    }
    
    func matchMarker(peg: Int) -> some View {
        let exactCount = matches.count { $0 == .exact }
        let foundCount = matches.count { $0 != .nomatch }
        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2)
            .aspectRatio(1, contentMode: .fit)
        
    }
}

#Preview {
    MatchMarkers(matches: [.exact, .exact, .inexact, .nomatch])
}
