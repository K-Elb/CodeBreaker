//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 26/12/2025.
//

import Foundation
import SwiftData

@Model
final class CodeBreaker {
    var name: String = ""
    @Relationship(deleteRule: .cascade) var masterCode: Code = Code(kind: .master(isHidden: true))
    @Relationship(deleteRule: .cascade) var guess: Code = Code(kind: .guess)
    @Relationship(deleteRule: .cascade, inverse: \Code.game) var _attempts: [Code] = []
    var pegChoices: [Peg.RawValue] = []
    @Transient var startTime: Date? // doesn't change UI
    var endTime: Date?
    var elapsedTime: TimeInterval = 0
    var lastAttemptDate: Date? = Date.now
    var isOver: Bool = false
    
    init() { }
    
    init(name: String = "Code Breaker", pegChoices : [Peg.RawValue]) {
        self.name = name
        self.pegChoices = pegChoices
        masterCode.randomise(from: pegChoices)
    }
    
    var attempts: [Code] {
        get { _attempts.sorted {$0.timestamp > $1.timestamp} }
        set { _attempts = newValue }
    }
    
    func startTimer() {
        if startTime == nil, !isOver {
            startTime = .now
            elapsedTime += 0.0000042
        }
    }
    
    func pauseTimer() {
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }
        
        startTime = nil
    }
    
    func updateElapsedTime() {
        pauseTimer()
        startTimer()
    }
    
    func restart() {
        masterCode.kind = .master(isHidden: true)
        masterCode.randomise(from: pegChoices)
        guess.reset()
        attempts.removeAll()
        startTime = .now
        endTime = nil
        elapsedTime = 0
        isOver = false
    }
    
    func attemptGuess() {
        guard !attempts.contains(where: { $0.pegs == guess.pegs }) else { return }
        let attempt = Code(kind: .attempt(guess.match(against: masterCode)), pegs: guess.pegs)
        attempts.insert(attempt, at: 0)
        lastAttemptDate = Date.now
        guess.reset()
        if attempts.first?.pegs == masterCode.pegs {
            isOver = true
            masterCode.kind = .master(isHidden: false)
            endTime = .now
            pauseTimer()
        }
    }
    
    func setGuessPeg(_ peg: Peg.RawValue, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
}
