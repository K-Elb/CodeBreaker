//
//  Code.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 28/12/2025.
//


import SwiftUI

struct Code {
    var kind: Kind
    var pegs: [Peg] = Array(repeating: Code.missingPeg, count: 4)
    
    static let missingPeg: Peg = .clear
    
    enum Kind: Equatable {
        case master
        case guess
        case attempt([Match])
        case unkown
    }
    
    mutating func randomise(from pegChoices: [Peg]) {
        for index in pegChoices.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missingPeg
        }
    }
    
    var matches: [Match]? {
        switch kind {
        case .attempt(let matches): return matches
        default: return nil
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        var pegsToMatch = otherCode.pegs
        
        let backwardsExactMatches = pegs.indices.reversed().map { index in
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                pegsToMatch.remove(at: index)
                return Match.exact
            } else {
                return .nomatch
            }
        }
        
        let exactMatches = Array(backwardsExactMatches.reversed())
        
        return pegs.indices.map { index in
            if exactMatches[index] != .exact, let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    pegsToMatch.remove(at: matchIndex)
                return .inexact
            } else {
                return exactMatches[index]
            }
        }
    }
}