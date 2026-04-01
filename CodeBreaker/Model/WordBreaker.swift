//
//  WordBreaker.swift
//  CodeBreaker
//
//  Created by Karim Elbehiri on 07/01/2026.
//

import Foundation

@Observable
class WordBreaker: Equatable {
    var name: String = "Word Breaker"
    var codeLength: Int
    var masterWord: Code
    var guess: Code
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
    
    init(codeLength: Int = 5, word: String = "") {
        self.codeLength = codeLength
        self.masterWord = Code(kind: .master(isHidden: true), pegs: Array(repeating: "", count: codeLength))
        self.guess = Code(kind: .guess, pegs: Array(repeating: "", count: codeLength))
//        guess.reset(length: codeLength)
        randomWord(word: word)
    }
    
    static func == (lhs: WordBreaker, rhs: WordBreaker) -> Bool {
        lhs.name == rhs.name
    }
    
    func randomWord(word: String) {
//        if let masterword = words.random(length: codeLength) {
            masterWord = Code(kind: .master(isHidden: true), pegs: [])
            for char in word {
                masterWord.pegs.append("\(char)")
            }
            print(masterWord.pegs)
//        }
    }
    
    func restart() {
        guess.reset(length: codeLength)
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
        guess.reset(length: codeLength)
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
    
    func updateElapsedTime() {
        pauseTimer()
        startTimer()
    }
}
