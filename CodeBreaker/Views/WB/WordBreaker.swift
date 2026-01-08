//
//  WordBreaker.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 07/01/2026.
//

import Foundation

@Observable
class WordBreaker {
    var name: String = ""
    var masterWord: Code = Code(kind: .master(isHidden: true), pegs: Array(repeating: "", count: 5))
    var guess: Code = Code(kind: .guess, pegs: Array(repeating: "", count: 5))
    var _attempts: [Code] = []
    var startTime: Date?
    var endTime: Date?
    var elapsedTime: TimeInterval = 0
    var lastAttemptDate: Date? = Date.now
    var isOver: Bool = false
    
    var attempts: [Code] {
        get { _attempts.sorted {$0.timestamp > $1.timestamp} }
        set { _attempts = newValue }
    }
    
    func restart() {
        guess.reset(length: 5)
        attempts.removeAll()
        startTime = .now
        endTime = nil
        elapsedTime = 0
        isOver = false
    }
    
    func attemptGuess() {
        guard !attempts.contains(where: { $0.pegs == guess.pegs }) else { return }
        let attempt = Code(kind: .attempt(guess.match(against: masterWord)), pegs: guess.pegs)
        attempts.insert(attempt, at: 0)
        lastAttemptDate = Date.now
        guess.reset(length: 5)
        if attempts.first?.pegs == masterWord.pegs {
            isOver = true
            masterWord.kind = .master(isHidden: false)
            endTime = .now
            pauseTimer()
        }
    }
    
    func setGuessPeg(_ peg: Peg.RawValue, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
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
}
