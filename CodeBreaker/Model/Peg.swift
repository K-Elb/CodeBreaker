//
//  Peg.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 30/12/2025.
//

import SwiftUI

enum Peg {
    case clear, red, blue, green, cyan, orange
    
    var color: Color {
        switch self {
        case .red: return .red
        case .blue: return .blue
        case .green: return .green
        case .cyan: return .cyan
        case .orange: return .orange
        default : return .clear
        }
    }
    
    var symbol: String {
        switch self {
        case .red: return "heart.fill"
        case .blue: return "drop.fill"
        case .green: return "leaf.fill"
        case .cyan: return "bolt.fill"
        case .orange: return "flame.fill"
        default: return ""
        }
    }
}
