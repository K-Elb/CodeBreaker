//
//  Peg.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 30/12/2025.
//

import SwiftUI

enum Peg {
    case clear, red, blue, green, cyan, orange, yellow, mint, pink, purple
    
    var color: Color {
        switch self {
        case .red: return .red
        case .blue: return .blue
        case .green: return .green
        case .cyan: return .cyan
        case .orange: return .orange
        case .yellow: return .yellow
        case .mint: return .mint
        case .pink: return .pink
        case .purple: return .purple
        default : return .clear
        }
    }
    
    var symbol: String {
        switch self {
        case .red: return "heart.fill"
        case .blue: return "drop.fill"
        case .green: return "tree.fill"
        case .cyan: return "bolt.fill"
        case .orange: return "flame.fill"
        case .yellow: return "sun.max.fill"
        case .mint: return "leaf.fill"
        case .pink: return "brain.fill"
        case .purple: return "sparkles"
        default: return "circle"
        }
    }
}

//extension Peg: Identifiable, Hashable, Equatable {
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}
