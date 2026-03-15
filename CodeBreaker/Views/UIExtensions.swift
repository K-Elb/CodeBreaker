//
//  UIExtensions.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 30/12/2025.
//

import SwiftUI

extension Animation {
    static let codeBreaker = Animation.default
    static let guess = Animation.codeBreaker
    static let restart = Animation.codeBreaker
    static let selection = Animation.codeBreaker
}

extension AnyTransition {
    static let pegChooser = AnyTransition.offset(y: 200)
    static func attempt(_ isOver: Bool) -> AnyTransition {
        AnyTransition.asymmetric(
            insertion: isOver ? .opacity : .move(edge: .top),
            removal: .push(from: .top)
        )
    }
}

extension View {
    func flexibleSystemFont(min: CGFloat = 4, max: CGFloat = 32) -> some View {
        self
            .font(.system(size: max))
            .minimumScaleFactor(min/max)
    }
}

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}
